import 'package:flutter/material.dart';
import '../controllers/visit_controller.dart';

class GuestScreen extends StatelessWidget {
  final VisitController controller;

  final String meno;
  final String auto;
  final String farba;
  final String spz;
  final String zaKym;

  final VoidCallback onEditGuest;
  final VoidCallback onOpenRamp;

  const GuestScreen({
    super.key,
    required this.controller,
    required this.meno,
    required this.auto,
    required this.farba,
    required this.spz,
    required this.zaKym,
    required this.onEditGuest,
    required this.onOpenRamp,
  });

  @override
  Widget build(BuildContext context) {
    final canOpen =
        meno.isNotEmpty &&
            auto.isNotEmpty &&
            spz.isNotEmpty &&
            controller.activeVisit == null;

    return Column(
      children: [
        // ================== HORNÁ POLOVICA ==================
        Expanded(
          flex: 1,
          child: _tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title('MOJE ÚDAJE'),
                _value(meno, 'Meno', big: true),
                _value(auto, 'Auto'),
                _value(farba, 'Farba'),
                _value(spz, 'SPZ', spaced: true),
                _value(zaKym, 'Za kým idem'),
                const Spacer(),
                ElevatedButton(
                  onPressed: onEditGuest,
                  child: const Text('UPRAVIŤ'),
                ),
              ],
            ),
          ),
        ),

        // ================== DOLNÁ POLOVICA ==================
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: canOpen ? onOpenRamp : null,
            borderRadius: BorderRadius.circular(16),
            child: _tile(
              color: canOpen ? Colors.green.shade700 : Colors.grey.shade700,
              child: const Center(
                child: Text(
                  'OTVORIŤ RAMPU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================== UI HELPERS ==================

  Widget _tile({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );

  Widget _value(String v, String p,
      {bool big = false, bool spaced = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: v.isEmpty
          ? Text(p, style: const TextStyle(color: Colors.white54))
          : Text(
        v,
        style: TextStyle(
          fontSize: big ? 22 : 20,
          fontWeight: big ? FontWeight.bold : FontWeight.normal,
          letterSpacing: spaced ? 2 : 0,
        ),
      ),
    );
  }
}
