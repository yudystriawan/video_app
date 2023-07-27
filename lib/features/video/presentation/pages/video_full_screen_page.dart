// import 'package:auto_route/auto_route.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../bloc/video_player/video_player_bloc.dart';
// import '../bloc/video_player/video_player_bloc.dart';

// @RoutePage()
// class VideoPlayerScreen extends StatefulWidget {
//   const VideoPlayerScreen({super.key});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerBloc _videoPlayer;
//   late ChewieController _chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayer = context.read<VideoPlayerBloc>();
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayer.videoPlayerController!,
//       autoPlay: true,
//       fullScreenByDefault: true,
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayer.add(const VideoPlayerEvent.stopped());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => true,
//       child: Scaffold(
//         body: Chewie(
//           controller: _chewieController,
//         ),
//       ),
//     );
//   }
// }
