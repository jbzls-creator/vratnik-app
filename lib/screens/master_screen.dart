import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VisitController>();
    final Visit? visit = controller.activeVisit;

    return Column(
      children: [
        // ===== PREPÍNAČ =====
        Padding(
          padding: const EdgeInsets.all(12),
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

        const Divider(height: 1),

        // ===== OBSAH =====
        Expanded(
          child: showHistory
              ? const HistoryScreen()
              : _currentRequestView(controller, visit),
        ),
      ],
    );
  }

  // ================== AKTUÁLNA POŽIADAVKA ==================

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
        Expanded(
          flex: 1,
          child: _tile(
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
              ],
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Center(
            child: SizedBox(
              width: 340,
              height: 110,
              child: ElevatedButton(
                onPressed: controller.activeVisitId == null
                    ? null
                    : controller.approveRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  disabledBackgroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  'OTVORIŤ RAMPU',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================== UI HELPERS ==================

  Widget _tabButton({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.orange.shade700 : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _tile({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
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
