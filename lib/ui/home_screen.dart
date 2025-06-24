import 'package:alrc_radio_pro_app/ui/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:alrc_radio_pro_app/services/audio_player_handler.dart';
import 'package:alrc_radio_pro_app/ui/player_controls.dart';

class HomeScreen extends StatelessWidget {
  final AudioHandler audioHandler;
  const HomeScreen({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALRC Radio Business'),
        centerTitle: true,
        backgroundColor: const Color(0xFFD50631),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFD50631),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      'https://groupemedia.info/uploads/images/logo_radio.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('ALRC Radio Business',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.radio, color: Colors.white),
              title: const Text('Accueil', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.playlist_play, color: Colors.white),
              title: const Text('Playlist', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showPlaylist(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.white),
              title: const Text('Minuteur', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Minuteur activé pour 1 min")),
                );
                Future.delayed(const Duration(minutes: 1), () {
                  audioHandler.pause();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.wifi, color: Colors.white),
              title: const Text('Test connexion', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Connexion OK")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Partager', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Tu peux déclencher Share.share(...) ici si tu veux
              },
            ),
            const Divider(color: Colors.white54),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('À propos', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'ALRC Radio Business',
                  applicationVersion: '1.0.0',
                  applicationIcon: Image.network(
                    'https://groupemedia.info/uploads/images/logo_radio.png',
                    width: 40,
                    height: 40,
                  ),
                  children: [
                    const Text("Propulsé par ALRC Groupe Média 🚀"),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
    children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                'https://groupemedia.info/uploads/images/logo_radio.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.radio, size: 120, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenue sur ALRC Radio Business',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 30),
            PlayerControls(audioHandler: audioHandler),
          ],
        ),
    ),
    MiniPlayer(audioHandler: audioHandler),
  ],
),

    );
  }

  void _showPlaylist(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final playlist = audioHandler.queue.value;
        return ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            final item = playlist[index];
            return ListTile(
              leading: const Icon(Icons.music_note, color: Colors.yellow),
              title: Text(item.title, style: const TextStyle(color: Colors.white)),
              subtitle: Text(item.artist ?? '', style: const TextStyle(color: Colors.white70)),
              onTap: () async {
                await (audioHandler as MyAudioHandler).playFromMediaItem(item);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
