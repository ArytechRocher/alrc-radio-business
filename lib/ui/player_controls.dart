import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PlayerControls extends StatefulWidget {
  final AudioHandler audioHandler;

  const PlayerControls({super.key, required this.audioHandler});

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  double _volume = 1.0;
  bool _isFavorited = false;
  Timer? _sleepTimer;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isFavorited
          ? 'Ajouté aux favoris ❤️'
          : 'Retiré des favoris 💔'),
    ));
  }

  void _setSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    _sleepTimer = Timer(duration, () {
      widget.audioHandler.pause();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⏱️ Lecture arrêtée par le minuteur")));
    });
  }

  Future<void> _checkConnection() async {
    var connectivity = await (Connectivity().checkConnectivity());
    final hasConnection = connectivity != ConnectivityResult.none;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(hasConnection
          ? "✅ Connexion Internet active"
          : "❌ Pas de connexion Internet"),
    ));
  }

  void _shareApp() {
    Share.share(
        "🎧 Écoutez la Radio Business de l'ALRC : https://groupemedia.info");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: widget.audioHandler.playbackState,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;

        return Column(
          children: [
             const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: _isFavorited ? Colors.yellow : Colors.white,
                  onPressed: _toggleFavorite,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.yellow),
                  onPressed: () => widget.audioHandler.skipToPrevious(),
                ),
                IconButton(
                  icon: Icon(
                    playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 64,
                    color: Colors.yellow,
                  ),
                  onPressed: () => playing
                      ? widget.audioHandler.pause()
                      : widget.audioHandler.play(),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.yellow),
                  onPressed: () => widget.audioHandler.skipToNext(),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  color: Colors.white,
                  onPressed: _shareApp,
                ),
              ],
            ),            
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.timer),
                  label: const Text("Minuteur"),
                  onPressed: () => _setSleepTimer(const Duration(minutes: 1)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.wifi),
                  label: const Text("Connexion"),
                  onPressed: _checkConnection,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
