import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visit.dart';

class VisitController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot>? _masterSubscription;
  StreamSubscription<DocumentSnapshot>? _guestSubscription;

  // ================= GUEST DATA =================

  String meno = '';
  String auto = '';
  String farba = '';
  String spz = '';
  String zaKym = '';

  bool _guestLoaded = false;

  // ================= STATE =================

  Visit? activeVisit;
  String? activeVisitId;

  final List<Visit> history = [];

  // ================= INIT =================

  VisitController() {
    _init();
  }

  Future<void> _init() async {
    await _loadGuestFromStorage();
    await loadHistoryFromFirestore();
    _listenForRequests();
  }

  // ================= LOCAL STORAGE =================

  Future<void> _loadGuestFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    meno = prefs.getString('guest_meno') ?? '';
    auto = prefs.getString('guest_auto') ?? '';
    farba = prefs.getString('guest_farba') ?? '';
    spz = prefs.getString('guest_spz') ?? '';
    zaKym = prefs.getString('guest_zaKym') ?? '';

    _guestLoaded = true;
    notifyListeners();
  }

  Future<void> _saveGuestToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('guest_meno', meno);
    await prefs.setString('guest_auto', auto);
    await prefs.setString('guest_farba', farba);
    await prefs.setString('guest_spz', spz);
    await prefs.setString('guest_zaKym', zaKym);
  }

  // ================= GUEST =================

  void updateGuest({
    required String meno,
    required String auto,
    required String farba,
    required String spz,
    required String zaKym,
  }) {
    if (activeVisitId != null) return;

    this.meno = meno;
    this.auto = auto;
    this.farba = farba;
    this.spz = spz;
    this.zaKym = zaKym;

    _saveGuestToStorage();
    notifyListeners();
  }

  bool get canOpenRamp =>
      _guestLoaded &&
          meno.isNotEmpty &&
          auto.isNotEmpty &&
          spz.isNotEmpty &&
          activeVisitId == null;

  Future<void> openRamp() async {
    if (!canOpenRamp) return;

    final doc = await _db.collection('requests').add({
      'name': meno,
      'auto': auto,
      'farba': farba,
      'carPlate': spz,
      'zaKym': zaKym,
      'status': 'pending',
      'createdAtClient': Timestamp.now(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    activeVisitId = doc.id;
    activeVisit = Visit(
      meno: meno,
      auto: auto,
      farba: farba,
      spz: spz,
      zaKym: zaKym,
      time: DateTime.now(),
    );

    _listenForOwnRequest();
    _startTimeout();
    notifyListeners();
  }

  // ================= TIMEOUT =================

  void _startTimeout() {
    Future.delayed(const Duration(minutes: 1), () async {
      if (activeVisitId == null) return;

      final doc = await _db.collection('requests').doc(activeVisitId).get();
      if (!doc.exists) return;

      if (doc.data()?['status'] == 'pending') {
        await _db.collection('requests').doc(activeVisitId).update({
          'status': 'expired',
          'expiredAt': FieldValue.serverTimestamp(),
        });

        activeVisit = null;
        activeVisitId = null;
        notifyListeners();
      }
    });
  }

  // ================= GUEST LISTENER =================

  void _listenForOwnRequest() {
    if (activeVisitId == null) return;

    _guestSubscription?.cancel();
    _guestSubscription = _db
        .collection('requests')
        .doc(activeVisitId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final status = snapshot.data()?['status'];

      if (status == 'approved' || status == 'expired') {
        if (status == 'approved' && activeVisit != null) {
          history.insert(0, activeVisit!);
        }

        activeVisit = null;
        activeVisitId = null;

        _guestSubscription?.cancel();
        _guestSubscription = null;
        notifyListeners();
      }
    });
  }

  // ================= MASTER LISTENER =================

  void _listenForRequests() {
    _masterSubscription?.cancel();

    _masterSubscription = _db
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAtClient')
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        activeVisit = null;
        activeVisitId = null;
        notifyListeners();
        return;
      }

      final doc = snapshot.docs.first;
      final data = doc.data();

      activeVisitId = doc.id;
      activeVisit = Visit(
        meno: data['name'] ?? '',
        auto: data['auto'] ?? '',
        farba: data['farba'] ?? '',
        spz: data['carPlate'] ?? '',
        zaKym: data['zaKym'] ?? '',
        time: (data['createdAtClient'] as Timestamp?)?.toDate() ??
            DateTime.now(),
      );

      notifyListeners();
    });
  }

  // ================= HISTORY (FIRESTORE) =================

  Future<void> loadHistoryFromFirestore() async {
    final snapshot = await _db
        .collection('requests')
        .where('status', isEqualTo: 'approved')
        .orderBy('approvedAt', descending: true)
        .limit(50)
        .get();

    history.clear();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      history.add(
        Visit(
          meno: data['name'] ?? '',
          auto: data['auto'] ?? '',
          farba: data['farba'] ?? '',
          spz: data['carPlate'] ?? '',
          zaKym: data['zaKym'] ?? '',
          time: (data['approvedAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
        ),
      );
    }

    notifyListeners();
  }

  // ================= APPROVE =================

  Future<void> approveRequest() async {
    if (activeVisitId == null) return;

    await _db.collection('requests').doc(activeVisitId).update({
      'status': 'approved',
      'approvedAt': FieldValue.serverTimestamp(),
    });

    await loadHistoryFromFirestore();

    activeVisit = null;
    activeVisitId = null;
    notifyListeners();
  }

  // ================= CLEANUP =================

  @override
  void dispose() {
    _masterSubscription?.cancel();
    _guestSubscription?.cancel();
    super.dispose();
  }
}
