import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resona/core/providers/current_user_notifier.dart';
import 'package:resona/core/theme/theme.dart';
import 'package:resona/features/auth/view-model/auth_viewmodel.dart';
import 'package:resona/features/auth/view/pages/signup_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/features/auth/view/pages/splash_screen.dart';
import 'package:resona/features/home/view/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  final container = ProviderContainer();

  await container.read(authViewmodelProvider.notifier).initSharedPreferences();
  await container.read(authViewmodelProvider.notifier).getData();

  runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Resona',
      theme: AppTheme.darkThemeMode,
      home: SplashScreen(),
    );
  }
}

