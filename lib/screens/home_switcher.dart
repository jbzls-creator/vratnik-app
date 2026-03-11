import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ================== AUTO TIME ==================

  int autoSeconds = 5;

  Future<void> _loadAutoSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoSeconds = prefs.getInt('autoApproveSeconds') ?? 5;
    });
  }

  Future<void> _setAutoSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('autoApproveSeconds', seconds);
    setState(() {
      autoSeconds = seconds;
    });
  }

  void _showAutoTimeDialog() {

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(
          title: const Text("Auto otvorenie rampy"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                title: const Text("5 sekúnd"),
                onTap: () {
                  _setAutoSeconds(5);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("10 sekúnd"),
                onTap: () {
                  _setAutoSeconds(10);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("30 sekúnd"),
                onTap: () {
                  _setAutoSeconds(30);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );

      },
    );

  }

  // ================== LOCK ==================

  void _onLockPressed() {
    _showPinDialog();
  }

  void _showPinDialog() {

    final pinCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {

        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 250),
          tween: Tween<double>(begin: 0.9, end: 1),
          curve: Curves.easeOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Text(
                        'Zadaj PIN',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: pinCtrl,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [

                          Expanded(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true).pop(),
                              child: const Text('Zrušiť'),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {

                                if (pinCtrl.text == masterPin) {

                                  Navigator.of(context, rootNavigator: true).pop();

                                  setState(() {
                                    isMasterUI = !isMasterUI;
                                  });

                                } else {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Nesprávny PIN"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );

                                }

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('OK'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

      },
    );

  }

  // ================== INIT ==================

  @override
  void initState() {
    super.initState();
    _loadAutoSeconds();
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {

    context.watch<VisitController>();

    return Scaffold(
      appBar: AppBar(

        title: Text(
          isMasterUI
              ? 'MASTER – Vrátnik'
              : 'Vrátnik – hosť',
        ),

        actions: [

          // ⏱ AUTO TIME
          if (isMasterUI)
            IconButton(
              icon: const Icon(Icons.timer),
              onPressed: _showAutoTimeDialog,
            ),

          // 🔒 LOCK
          IconButton(
            icon: Icon(
                isMasterUI ? Icons.lock_open : Icons.lock),
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
