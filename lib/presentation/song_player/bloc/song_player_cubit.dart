import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();

  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;

  bool isRepeat = false;
  bool isPlaying = false;

  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration ?? Duration.zero;
      updateSongPlayer();
    });

    audioPlayer.playerStateStream.listen((playerState) {
      isPlaying = playerState.playing;

      if (playerState.processingState == ProcessingState.completed) {
        isPlaying = false;
        songPosition = songDuration;
      }

      emit(SongPlayerLoaded());
    });
  }

  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }

  Future<void> loadSong(String path) async {
    try {
      await audioPlayer.setAsset('assets/songs/$path');
      songDuration = audioPlayer.duration ?? Duration.zero;

      emit(SongPlayerLoaded());
    } catch (e) {
      emit(SongPlayerFailure());
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }

  void seekSong(Duration position) {
    audioPlayer.seek(position);
    emit(SongPlayerLoaded());
  }

  void toggleRepeat() {
    isRepeat = !isRepeat;
    if (isRepeat) {
      audioPlayer.setLoopMode(LoopMode.one);
    } else {
      audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
