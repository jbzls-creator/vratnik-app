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

  bool isMasterUI = false;

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

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    // controller tu zatiaľ len “držime nažive”
    context.watch<VisitController>();

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
          : const GuestScreen(),
    );
  }
}
