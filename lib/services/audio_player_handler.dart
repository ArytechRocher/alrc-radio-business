import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  late final List<MediaItem> _mediaItems;

  

  MyAudioHandler() {
    _mediaItems = [
      const MediaItem(
        id: 'https://groupemedia.info/uploads/audio/podcast-music-interview-intro-vlog-radio-youtube-background-theme-286235.mp3',
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
      const MediaItem(
        id: 'https://groupemedia.info/uploads/audio/radio-jingle-356063.mp3',
        album: 'ALRC Radio',
        title: 'Présentation Officielle',
        artist: 'ALRC Groupe Média',
      ),
      // Tu peux ajouter d'autres MediaItem ici...
    ];
    _init();
  }

  


  Future<void> _init() async {
    // Met à jour la queue de AudioService
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

    // Configure les sources audio dans just_audio
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: _mediaItems.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
    );

    // Configure le player avec la playlist
    await _player.setAudioSource(playlist);

    // Boucle sur toute la playlist
    _player.setLoopMode(LoopMode.all);

    // Sync MediaItem avec le morceau en cours
    _player.currentIndexStream.listen((index) {
      if (index != null && index < _mediaItems.length) {
        mediaItem.add(_mediaItems[index]);
      }
    });

    // Sync lecture/pause/next/prev
    playbackState.add(_transformEvent(_player.playbackEvent));
    _player.playbackEventStream.listen((event) {
      playbackState.add(_transformEvent(event));
    });
  }



  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();


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

  @override
  Future<void> stop() => _player.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
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
