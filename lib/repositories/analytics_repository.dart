import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsRepository {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
