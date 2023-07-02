part of 'video_player_bloc.dart';

@freezed
class VideoPlayerState with _$VideoPlayerState{
  const factory VideoPlayerState({
    VideoPlayerController? controller,
    Video? currentVideo,
  }) = _VideoPlayerState;

  factory VideoPlayerState.initial() => const VideoPlayerState();  
}


// @freezed
// class VideoPlayerState with _$VideoPlayerState {
//   const factory VideoPlayerState({
//     Video? videoSelected,
//   }) = _VideoPlayerState;

//   factory VideoPlayerState.initial() => const VideoPlayerState();
// }

// @freezed
// class VideoPlayerState with _$VideoPlayerState {
//   const VideoPlayerState._();
  
//   const factory VideoPlayerState({
//     @Default(VideoPlayerStatus.initial) VideoPlayerStatus status,
//     Video? currentVideo,
//   }) = _VideoPlayerState;

//   factory VideoPlayerState.initial() => const VideoPlayerState();

//   bool get isLoading => status == VideoPlayerStatus.loading;
//   bool get isPlaying => status == VideoPlayerStatus.play;
//   bool get isStop => status == VideoPlayerStatus.stop;
//   bool get isResume => status == VideoPlayerStatus.resume;
//   bool get isPause => status == VideoPlayerStatus.pause;
// }

// enum VideoPlayerStatus {
//   initial,
//   loading,
//   play,
//   stop,
//   resume,
//   pause,
// }
