import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import './core/constants/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SentryFlutter.init((options) {
    options.dsn =
        'https://584f9ec52897e3a61bdecd3842ef86ca@o4510507555094528.ingest.de.sentry.io/4510507556470864';
    options.sendDefaultPii = true;
    options.enableLogs = true;
    options.tracesSampleRate = 1.0;
    options.profilesSampleRate = 1.0;
    options.replay.sessionSampleRate = 0.1;
    options.replay.onErrorSampleRate = 1.0;
  }, appRunner: () => runApp(SentryWidget(child: const MyApp())));
  await Sentry.captureException(StateError(AppStrings.genericError));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
