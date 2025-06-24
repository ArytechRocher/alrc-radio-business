import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class MiniPlayer extends StatelessWidget {
  final AudioHandler audioHandler;
  const MiniPlayer({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final media = mediaSnapshot.data;

        return StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data?.playing ?? false;

            if (media == null) return const SizedBox();

            return Container(
              color: const Color(0xFFD50631),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.yellow),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(media.title,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                        if (media.artist != null)
                          Text(media.artist!,
                              style: const TextStyle(color: Colors.white70),
                              overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.yellow,
                      size: 32,
                    ),
                    onPressed: () => isPlaying
                        ? audioHandler.pause()
                        : audioHandler.play(),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
