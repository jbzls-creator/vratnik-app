import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/visit_controller.dart';

class GuestScreen extends StatelessWidget {
  const GuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VisitController>();

    final bool hasData =
        controller.meno.isNotEmpty &&
            controller.auto.isNotEmpty &&
            controller.spz.isNotEmpty;

    final bool canOpen =
        hasData && controller.activeVisit == null;

    return SafeArea(
      child: Column(
        children: [

          // ================== HORNÁ ČASŤ (SCROLL) ==================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _tile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hasData) _title('MOJE ÚDAJE'),

                    _value(controller.meno, 'Meno',
                        size: 28, weight: FontWeight.w600),
                    _value(controller.auto, 'Auto',
                        size: 26, weight: FontWeight.w500),
                    _value(controller.farba, 'Farba', size: 24),
                    _value(
                      controller.spz,
                      'SPZ',
                      size: 26,
                      spaced: true,
                      weight: FontWeight.w600,
                    ),
                    _value(controller.zaKym, 'Za kým idem', size: 18),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: 160,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => _editGuestData(context, controller),
                        child: const Text(
                          'UPRAVIŤ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================== TLAČIDLO DOLE ==================
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SizedBox(
              width: 340,
              height: 110,
              child: ElevatedButton(
                onPressed: canOpen ? controller.openRamp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  disabledBackgroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'OTVORIŤ RAMPU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================== EDIT DIALOG ==================

  void _editGuestData(
      BuildContext context, VisitController controller) {
    final menoCtrl = TextEditingController(text: controller.meno);
    final autoCtrl = TextEditingController(text: controller.auto);
    final farbaCtrl = TextEditingController(text: controller.farba);
    final spzCtrl = TextEditingController(text: controller.spz);
    final zaKymCtrl = TextEditingController(text: controller.zaKym);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Upraviť údaje'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: menoCtrl,
                    decoration:
                    const InputDecoration(labelText: 'Meno')),
                TextField(
                    controller: autoCtrl,
                    decoration:
                    const InputDecoration(labelText: 'Auto')),
                TextField(
                    controller: farbaCtrl,
                    decoration:
                    const InputDecoration(labelText: 'Farba')),
                TextField(
                    controller: spzCtrl,
                    decoration:
                    const InputDecoration(labelText: 'SPZ')),
                TextField(
                    controller: zaKymCtrl,
                    decoration:
                    const InputDecoration(labelText: 'Za kým idem')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Zrušiť'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateGuest(
                  meno: menoCtrl.text.trim(),
                  auto: autoCtrl.text.trim(),
                  farba: farbaCtrl.text.trim(),
                  spz: spzCtrl.text.trim(),
                  zaKym: zaKymCtrl.text.trim(),
                );
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Uložiť'),
            ),
          ],
        );
      },
    );
  }

  // ================== UI HELPERS ==================

  Widget _tile({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _value(
      String v,
      String placeholder, {
        required double size,
        FontWeight weight = FontWeight.normal,
        bool spaced = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: v.isEmpty
          ? Text(
        placeholder,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 18,
        ),
      )
          : Text(
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
