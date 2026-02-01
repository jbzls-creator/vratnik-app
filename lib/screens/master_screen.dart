import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/visit_controller.dart';
import '../models/visit.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VisitController>();
    final Visit? visit = controller.activeVisit;

    // ===== STAV: nič nečaká
    if (visit == null) {
      return const Center(
        child: Text(
          'Žiadna čakajúca požiadavka',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white54,
          ),
        ),
      );
    }

    // ===== STAV: je pending request
    return Column(
      children: [
        // ===== HORNÁ POLOVICA – INFO (rovnaká veľkosť ako hosť)
        Expanded(
          flex: 1,
          child: _tile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title('ŽIADOSŤ O VSTUP'),
                _value(visit.meno, 'Meno', big: true),
                _value(visit.auto, 'Auto'),
                _value(visit.farba, 'Farba'),
                _value(visit.spz, 'SPZ', spaced: true),
                _value(visit.zaKym, 'Za kým ide'),
              ],
            ),
          ),
        ),

        // ===== DOLNÁ POLOVICA – SCHVÁLIŤ
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: controller.activeVisitId == null
                ? null
                : () async {
              await controller.approveRequest();
            },
            borderRadius: BorderRadius.circular(16),
            child: _tile(
              color: Colors.orange.shade700,
              child: const Center(
                child: Text(
                  'OTVORIŤ RAMPU',
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
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _value(
      String v,
      String p, {
        bool big = false,
        bool spaced = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
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
