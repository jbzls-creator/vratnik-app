import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/visit_controller.dart';
import '../models/visit.dart';
import 'history_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {

  bool showHistory = false;

  Timer? _autoApproveTimer;
  Timer? _countdownTimer;

  int autoApproveSeconds = 5;
  int countdown = 0;

  String? _lastVisitId;

  Future<int> _getAutoApproveSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('autoApproveSeconds') ?? 5;
  }

  Future<void> _startAutoApproveTimer(VisitController controller) async {

    _autoApproveTimer?.cancel();
    _countdownTimer?.cancel();

    autoApproveSeconds = await _getAutoApproveSeconds();
    countdown = autoApproveSeconds;

    setState(() {});

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {

        if (countdown <= 1) {
          timer.cancel();
        }

        setState(() {
          countdown--;
        });

      },
    );

    _autoApproveTimer = Timer(
      Duration(seconds: autoApproveSeconds),
          () {

        _countdownTimer?.cancel();

        if (controller.activeVisitId != null) {
          controller.approveRequest();
        }

      },
    );
  }

  @override
  void dispose() {
    _autoApproveTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final controller = context.watch<VisitController>();
    final Visit? visit = controller.activeVisit;

    if (visit != null && controller.activeVisitId != _lastVisitId) {

      _lastVisitId = controller.activeVisitId;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoApproveTimer(controller);
      });

    }

    if (visit == null) {
      _lastVisitId = null;
      _autoApproveTimer?.cancel();
      _countdownTimer?.cancel();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF141E30),
                  Color(0xFF0F0C29),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tabButton(
                        title: 'AKTUÁLNE',
                        active: !showHistory,
                        onTap: () => setState(() => showHistory = false),
                      ),
                      const SizedBox(width: 12),
                      _tabButton(
                        title: 'HISTÓRIA',
                        active: showHistory,
                        onTap: () => setState(() => showHistory = true),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: showHistory
                      ? const HistoryScreen()
                      : _currentRequestView(controller, visit),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentRequestView(
      VisitController controller, Visit? visit) {

    if (visit == null) {
      return const Center(
        child: Text(
          'Žiadna čakajúca požiadavka',
          style: TextStyle(fontSize: 22, color: Colors.white54),
        ),
      );
    }

    return Column(
      children: [

        /// INFO PANEL
        Expanded(
          flex: 2,
          child: _tile(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _value(visit.meno, size: 28, weight: FontWeight.w600),
                        _value(visit.auto, size: 26),
                        _value(visit.farba, size: 24),

                        _value(
                          visit.spz,
                          size: 26,
                          spaced: true,
                          weight: FontWeight.w600,
                        ),

                        _value(visit.zaKym, size: 18),

                        const SizedBox(height: 20),

                        const Text(
                          "Automatické otvorenie za",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: Text(
                            "$countdown",
                            style: const TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        /// TLAČIDLO
        Expanded(
          flex: 1,
          child: Center(
            child: SizedBox(
              width: 340,
              height: 110,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  gradient: controller.activeVisitId != null
                      ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFB74D),
                      Color(0xFFF57C00),
                    ],
                  )
                      : null,

                  color: controller.activeVisitId != null
                      ? null
                      : Colors.white.withOpacity(0.05),

                  boxShadow: controller.activeVisitId != null
                      ? [
                    BoxShadow(
                      color: const Color(0xFFF57C00).withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ]
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: controller.activeVisitId == null
                        ? null
                        : () {

                      _autoApproveTimer?.cancel();
                      _countdownTimer?.cancel();
                      controller.approveRequest();

                    },
                    child: Center(
                      child: Text(
                        'OTVORIŤ RAMPU',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: controller.activeVisitId != null
                              ? Colors.black
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabButton({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: active
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.05),
          border: active
              ? Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : Colors.white70,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _tile({required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _value(
      String v, {
        required double size,
        FontWeight weight = FontWeight.normal,
        bool spaced = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        v,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spaced ? 3 : 0,
        ),
      ),
    );
  }
}
