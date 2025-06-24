import 'models/media_item_model.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  late final List<MediaItem> _mediaItems;

  

  MyAudioHandler() {
    _mediaItems = [
      const MediaItem(
        id: 'https://groupemedia.info/uploads/audio/presentation1.mp3',
        album: 'ALRC Radio',
        title: 'Présentation Officielle',
        artist: 'ALRC Groupe Média',
      ),
      const MediaItem(
        id: 'https://groupemedia.info/uploads/audio/presentation1.mp3',
        album: 'ALRC Radio',
        title: 'Présentation Officielle',
        artist: 'ALRC Groupe Média',
      ),
      // Tu peux ajouter d'autres MediaItem ici...
    ];
    _init();
  }

  Future<void> _init() async {
    queue.add(_mediaItems);
    mediaItem.add(_mediaItems.first);

    try {
      await _player.setUrl(_mediaItems.first.id);
    } catch (e) {
      print("Erreur de chargement du flux audio: $e");
    }

    _player.playbackEventStream.listen((event) {
      playbackState.add(_transformPlaybackState());
    });
  }



  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() async {
    final current = mediaItem.value;
    

    final index = _mediaItems.indexOf(current!);
    if (index != -1 && index + 1 < _mediaItems.length) {
      final next = _mediaItems[index + 1];
      mediaItem.add(next);
      await _player.setUrl(next.id);
      await play();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final current = mediaItem.value;
    final index = _mediaItems.indexOf(current!);
    if (index > 0) {
      final prev = _mediaItems[index - 1];
      mediaItem.add(prev);
      await _player.setUrl(prev.id);
      await play();
    }
  }

  PlaybackState _transformPlaybackState() {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      playing: _player.playing,
      updatePosition: _player.position,
      processingState: AudioProcessingState.ready,
      systemActions: const {
        MediaAction.playPause,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
    );
  }

  void setMediaItem(MediaItem item) {
  mediaItem.add(item); // <- ici on utilise add car dans `BaseAudioHandler`, c’est bien un Subject
}

Future<void> playFromMediaItem(MediaItem item) async {
  setMediaItem(item);
  await _player.setUrl(item.id);
  await play();
}

}
