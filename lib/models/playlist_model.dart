import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class PlayerControls extends StatelessWidget {
  final AudioHandler audioHandler;

  const PlayerControls({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_down),
              onPressed: () {
                // À compléter si besoin
              },
            ),
            IconButton(
              icon: Icon(
                playing ? Icons.pause_circle : Icons.play_circle,
                size: 64,
                color: const Color(0xFFD50631),
              ),
              onPressed: () =>
                  playing ? audioHandler.pause() : audioHandler.play(),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {
                // À compléter si besoin
              },
            ),
          ],
        );
      },
    );
  }
}
