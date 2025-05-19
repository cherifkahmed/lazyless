import 'package:do_not_disturb/do_not_disturb.dart';

final dndPlugin = DoNotDisturbPlugin();


Future<void> checkDndStatus() async {
  bool isDndEnabled = await dndPlugin.isDndEnabled();
  print(isDndEnabled ? "Shh, we're in zen mode!" : "LOUD NOISES!");
}

Future<void> getDetailedDndStatus() async {
  InterruptionFilter status = await dndPlugin.getDNDStatus();
  switch (status) {
    case InterruptionFilter.all:
      print("All interruptions welcome. Chaos reigns!");
      break;
    case InterruptionFilter.priority:
      print("VIPs only. Sorry, telemarketers!");
      break;
    case InterruptionFilter.none:
      print("Maximum zen achieved. Not even your thoughts are allowed.");
      break;
    case InterruptionFilter.alarms:
      print("Alarms only. Because oversleeping is the real disturbance.");
      break;
    default:
      print("Unknown state. Did we enter the quantum realm?");
  }
}
//activate 
Future<void> embraceTheZen() async {
  if (await dndPlugin.isNotificationPolicyAccessGranted()) {
    await dndPlugin.setInterruptionFilter(InterruptionFilter.none);
    print("Zen mode activated. You are now one with the void.");
  } else {
    print("We need the sacred permission to control the zen!");
    await dndPlugin.openNotificationPolicyAccessSettings();
  }
}
// desactivate
Future<void> welcomenoise() async {
  if (await dndPlugin.isNotificationPolicyAccessGranted()) {
    await dndPlugin.setInterruptionFilter(InterruptionFilter.all);
    print("Zen mode disactivated.");
  } else {
    print("We need the sacred permission to control the zen!");
    await dndPlugin.openNotificationPolicyAccessSettings();
  }
}

Future<void> guideThroughDNDPermission() async {
  bool hasAccess = await dndPlugin.isNotificationPolicyAccessGranted();
  if (!hasAccess) {
    // Show a dialog explaining why you need this power
    bool userWantsToGrantAccess = await showExplanationDialog();

    if (userWantsToGrantAccess) {
      await dndPlugin.openNotificationPolicyAccessSettings();
    } else {
      print("User chose to remain in the noisy world. Their loss!");
    }
  } else {
    print("We have the power! Use it wisely, young padawan.");
  }
}

Future<bool> showExplanationDialog() async {
  // Simulate a dialog for testing purposes
  print("Showing explanation dialog...");
  return true; // Simulate user agreeing to grant permission
}
