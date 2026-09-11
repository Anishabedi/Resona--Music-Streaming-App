import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class AudioWave extends StatefulWidget{
  final String path;
  const AudioWave({super.key, required this.path,});
  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();
  int currentDuration = 0;
  int maxDuration =0;

  @override
  void initState(){
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async{
    await playerController.preparePlayer(
      path: widget.path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    maxDuration = playerController.maxDuration ?? 0;

    if (mounted) {
      setState(() {});   // UI refresh karo
    }

    // playerController.onCompletion.listen((_) {
    //   setState(() {});
    // });
    playerController.onCurrentDurationChanged.listen((duration) {
      if(mounted){
        setState(() {
          currentDuration = duration;
        });
      }
    });

  }

  Future<void> playAndPause() async {
    if(!playerController.playerState.isPlaying){
      await playerController.startPlayer();                     // bracket mei finishmode= finishmode.state likha hai
    }else if (!playerController.playerState.isPaused){
      await playerController.pausePlayer();
    }
    setState(() {});
  }
  @override
  void dispose() {
    playerController.pausePlayer();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Total duration
    Duration total = Duration(milliseconds: playerController.maxDuration);

// Current position
    Duration current = Duration(milliseconds: currentDuration );
    return Row(
      children: [
        IconButton(
          onPressed: playAndPause,
          icon: Icon(
            playerController.playerState.isPlaying ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid,
          ),
        ),
        Text(
          '${current.inMinutes}:${(current.inSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(color: Colors.white,fontSize: 12),
        ),
        Expanded(
          child: AudioFileWaveforms(
              size: const Size(double.infinity,100),
              playerController: playerController,
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Pallete.borderColor,
                liveWaveColor: Pallete.gradient2,
                spacing: 6,
                showSeekLine: false,
              ),
          ),
        ),
        Text(
          '${total.inMinutes}:${(total.inSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(color: Colors.white,fontSize: 12),
        ),
      ],
    );
  }
}