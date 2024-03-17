import 'package:audio_player/audio_player_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordedAudio extends StatelessWidget {
  RecordedAudio({Key? key}) : super(key: key);
  final AudioPlayerController audioPlayerController = Get.find();
  AudioPlayer player = AudioPlayer();
  AudioPlayer player1 = AudioPlayer();

  void volume1({double? value, String? audio}) async {
    player.setVolume(value ?? 0);
    await player.play(AssetSource(audio ?? ''));
  }

  void volume2({double? value, String? audio}) async {
    player1.setVolume(value ?? 0);
    await player1.play(AssetSource(audio ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        player.stop();
        player1.stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              player.stop();
              player1.stop();
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text('RecordedAudio'),
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: audioPlayerController.getMixUpAudio.value.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  player.stop();
                  player1.stop();
                  volume1(
                    value: audioPlayerController
                        .getMixUpAudio.value[index].volume1,
                    audio:
                        audioPlayerController.getMixUpAudio.value[index].audio1,
                  );
                  volume2(
                    value: audioPlayerController
                        .getMixUpAudio.value[index].volume2,
                    audio:
                        audioPlayerController.getMixUpAudio.value[index].audio2,
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 50,
                        width: 200,
                        child: Center(
                          child: Text(
                            "Play ${index}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
