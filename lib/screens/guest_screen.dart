import 'dart:ui';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          // ======== GRADIENT POZADIE =========
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

                // ================== HORNÁ ČASŤ ==================
                Expanded(
                  flex: 1,
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

                          const SizedBox(height: 24),

                          SizedBox(
                            width: 160,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _editGuestData(context, controller),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.white.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'UPRAVIŤ',
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ================== TLAČIDLO DOLE (rovnaká výška ako Master) ==================
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      width: 340,
                      height: 110,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(30),

                          gradient: canOpen
                              ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF00E676),
                              Color(0xFF00C853),
                            ],
                          )
                              : null,

                          color: canOpen
                              ? null
                              : Colors.white.withOpacity(0.05),

                          boxShadow: canOpen
                              ? [
                            BoxShadow(
                              color: const Color(0xFF00E676)
                                  .withOpacity(0.6),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ]
                              : [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.6),
                              blurRadius: 20,
                              offset:
                              const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                            BorderRadius.circular(30),
                            onTap: canOpen
                                ? controller.openRamp
                                : null,
                            child: Center(
                              child: Text(
                                'OTVORIŤ RAMPU',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: canOpen
                                      ? Colors.black
                                      : Colors.white
                                      .withOpacity(0.4),
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
            ),
          ),
        ],
      ),
    );
  }

  // ================== EDIT DIALOG ==================

  void _editGuestData(
      BuildContext context, VisitController controller) {
    final menoCtrl =
    TextEditingController(text: controller.meno);
    final autoCtrl =
    TextEditingController(text: controller.auto);
    final farbaCtrl =
    TextEditingController(text: controller.farba);
    final spzCtrl =
    TextEditingController(text: controller.spz);
    final zaKymCtrl =
    TextEditingController(text: controller.zaKym);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text('Upraviť údaje'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: menoCtrl, decoration: const InputDecoration(labelText: 'Meno')),
                TextField(controller: autoCtrl, decoration: const InputDecoration(labelText: 'Auto')),
                TextField(controller: farbaCtrl, decoration: const InputDecoration(labelText: 'Farba')),
                TextField(controller: spzCtrl, decoration: const InputDecoration(labelText: 'SPZ')),
                TextField(controller: zaKymCtrl, decoration: const InputDecoration(labelText: 'Za kým idem')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context,
                      rootNavigator: true)
                      .pop(),
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
                Navigator.of(context,
                    rootNavigator: true)
                    .pop();
              },
              child: const Text('Uložiť'),
            ),
          ],
        );
      },
    );
  }

  // ================== GLASS TILE ==================

  Widget _tile({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter:
        ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(28),
            color: Colors.white
                .withOpacity(0.06),
            border: Border.all(
              color: Colors.white
                  .withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.6),
                blurRadius: 25,
                offset:
                const Offset(0, 15),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _title(String t) => Padding(
    padding:
    const EdgeInsets.only(bottom: 14),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 26,
        fontWeight:
        FontWeight.bold,
      ),
    ),
  );

  Widget _value(
      String v,
      String placeholder, {
        required double size,
        FontWeight weight =
            FontWeight.normal,
        bool spaced = false,
      }) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 8),
      child: v.isEmpty
          ? Text(
        placeholder,
        style:
        const TextStyle(
          color: Colors.white54,
          fontSize: 18,
        ),
      )
          : Text(
        v,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          letterSpacing:
          spaced ? 3 : 0,
        ),
      ),
    );
  }
}
