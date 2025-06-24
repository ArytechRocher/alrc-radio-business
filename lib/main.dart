import 'package:flutter/material.dart';
import 'package:alrc_radio_pro_app/services/audio_player_handler.dart';
import 'package:alrc_radio_pro_app/ui/home_screen.dart';
import 'package:alrc_radio_pro_app/utils/app_theme.dart';
import 'package:audio_service/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
try{
  final audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.alrc.radio.channel.audio',
      androidNotificationChannelName: 'ALRC Radio',
      androidNotificationOngoing: true,
    ),
  );
  runApp(MyApp(audioHandler: audioHandler));
} catch (e, stack) {
      runApp(ErrorApp(error: e.toString()));
        }
}
}

class MyApp extends StatelessWidget {
  final AudioHandler audioHandler;
  const MyApp({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALRC Radio Business',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: HomeScreen(audioHandler: audioHandler),
    );
  }
}
