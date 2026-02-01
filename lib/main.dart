import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'controllers/visit_controller.dart';
import 'screens/home_switcher.dart';
import 'firebase_options.dart';
import 'controllers/requests_debug.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ❗❗❗ KRITICKÁ OPRAVA
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );

  await RequestsDebug.printRequests();

  runApp(
    ChangeNotifierProvider(
      create: (_) => VisitController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeSwitcher(),
    );
  }
}
