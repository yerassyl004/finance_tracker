import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// One of the three fixed daily reminders. The [id] must be stable so
/// rescheduling replaces (rather than duplicates) an existing reminder.
enum DailyReminder {
  morning(id: 1001, hour: 9, minute: 0),
  afternoon(id: 1002, hour: 14, minute: 0),
  evening(id: 1003, hour: 21, minute: 0);

  const DailyReminder({
    required this.id,
    required this.hour,
    required this.minute,
  });

  final int id;
  final int hour;
  final int minute;

  String get title {
    switch (this) {
      case DailyReminder.morning:
        return AppStrings.notifMorningTitle;
      case DailyReminder.afternoon:
        return AppStrings.notifAfternoonTitle;
      case DailyReminder.evening:
        return AppStrings.notifEveningTitle;
    }
  }

  String get body {
    switch (this) {
      case DailyReminder.morning:
        return AppStrings.notifMorningBody;
      case DailyReminder.afternoon:
        return AppStrings.notifAfternoonBody;
      case DailyReminder.evening:
        return AppStrings.notifEveningBody;
    }
  }
}

/// Thin wrapper around `flutter_local_notifications` that handles one-time
/// initialisation, runtime permission requests and scheduling the three
/// recurring daily reminders. Registered as a singleton in DI.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'daily_reminders';

  bool _initialized = false;

  /// Initialises the plugin, the timezone database and the Android channel.
  /// Safe to call multiple times.
  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // Permissions are requested explicitly later (see [requestPermissions]),
    // so don't prompt during initialisation.
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            AppStrings.notifChannelName,
            description: AppStrings.notifChannelDescription,
            importance: Importance.defaultImportance,
          ),
        );

    _initialized = true;
  }

  /// Requests notification permission from the OS. Returns true when granted
  /// (or when the platform grants implicitly). Never throws — a denied prompt
  /// simply means reminders won't fire.
  Future<bool> requestPermissions() async {
    await init();

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// (Re)schedules all three daily reminders. Existing schedules with the same
  /// ids are replaced, so this is idempotent.
  Future<void> scheduleDailyReminders() async {
    await init();
    for (final reminder in DailyReminder.values) {
      await _scheduleDaily(reminder);
    }
  }

  /// Cancels all pending reminders (e.g. if the user revokes permission).
  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> _scheduleDaily(DailyReminder reminder) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        AppStrings.notifChannelName,
        channelDescription: AppStrings.notifChannelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        reminder.id,
        reminder.title,
        reminder.body,
        _nextInstanceOf(reminder.hour, reminder.minute),
        details,
        // Inexact avoids requiring the exact-alarm permission on Android 12+;
        // a few minutes' drift is fine for reminders.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // Repeat every day at the same time of day.
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      // Scheduling can fail on some devices (e.g. exact-alarm restrictions);
      // don't let a reminder bring down the app.
      debugPrint('Failed to schedule ${reminder.name} reminder: $e');
    }
  }

  /// The next UTC instant matching the given local wall-clock time.
  ///
  /// We schedule in UTC (rather than a device IANA zone, which the `timezone`
  /// package can't detect on its own) computed from the current local offset.
  /// Combined with [DateTimeComponents.time] this repeats daily at the same
  /// local time, with a possible one-hour drift across daylight-saving changes.
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);
    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    return tz.TZDateTime.from(next.toUtc(), tz.UTC);
  }
}
