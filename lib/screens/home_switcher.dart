import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/visit_controller.dart';
import '../screens/guest_screen.dart';
import '../screens/master_screen.dart';

class HomeSwitcher extends StatefulWidget {
  const HomeSwitcher({super.key});

  @override
  State<HomeSwitcher> createState() => _HomeSwitcherState();
}

class _HomeSwitcherState extends State<HomeSwitcher> {
  static const String masterPin = '11223344';

  // 👤 údaje hosťa – len formulár
  String meno = '';
  String auto = '';
  String farba = '';
  String spz = '';
  String zaKym = '';

  bool isMasterUI = false; // 👈 LEN UI PREPÍNAČ

  // ================== LOCK ==================

  void _onLockPressed() {
    if (isMasterUI) {
      setState(() => isMasterUI = false);
    } else {
      _showPinDialog();
    }
  }

  void _showPinDialog() {
    final pinCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Zadaj PIN'),
          content: TextField(
            controller: pinCtrl,
            keyboardType: TextInputType.number,
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Zrušiť'),
            ),
            ElevatedButton(
              onPressed: () {
                if (pinCtrl.text == masterPin) {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() => isMasterUI = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ================== GUEST ==================

  void _editGuestData() {
    final menoCtrl = TextEditingController(text: meno);
    final autoCtrl = TextEditingController(text: auto);
    final farbaCtrl = TextEditingController(text: farba);
    final spzCtrl = TextEditingController(text: spz);
    final zaKymCtrl = TextEditingController(text: zaKym);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
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
                  Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Zrušiť'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  meno = menoCtrl.text.trim();
                  auto = autoCtrl.text.trim();
                  farba = farbaCtrl.text.trim();
                  spz = spzCtrl.text.trim();
                  zaKym = zaKymCtrl.text.trim();
                });
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Uložiť'),
            ),
          ],
        );
      },
    );
  }

  void _openRamp(VisitController controller) {
    controller.updateGuest(
      meno: meno,
      auto: auto,
      farba: farba,
      spz: spz,
      zaKym: zaKym,
    );
    controller.openRamp();
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VisitController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isMasterUI ? 'MASTER – Vrátnik' : 'Vrátnik – hosť'),
        actions: [
          IconButton(
            icon: Icon(isMasterUI ? Icons.lock_open : Icons.lock),
            onPressed: _onLockPressed,
          ),
        ],
      ),
      body: isMasterUI
          ? const MasterScreen()
          : GuestScreen(
        controller: controller,
        meno: meno,
        auto: auto,
        farba: farba,
        spz: spz,
        zaKym: zaKym,
        onEditGuest: _editGuestData,
        onOpenRamp: () => _openRamp(controller),
      ),
    );
  }
}
