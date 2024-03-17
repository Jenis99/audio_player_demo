import 'dart:convert';

import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/slider_step.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:audio_player/audio_player_controller.dart';
import 'package:audio_player/post_model.dart';
import 'package:audio_player/recorded_Audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AudioPlayerPage(),
    );
  }
}

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({Key? key}) : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AudioPlayerController audioPlayerController =
      Get.put(AudioPlayerController());
  final audioController = Get.put(AudioPlayerController());
  AudioPlayer player = AudioPlayer();
  AudioPlayer player1 = AudioPlayer();
  double _value = 0.0;
  double _value2 = 0.0;

  void volume1(double value) async {
    await player.play(AssetSource('epic.mp3'));
    player.setVolume(value);
  }

  void volume2(double value) async {
    await player1.play(AssetSource('drum.mp3'));
    player1.setVolume(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (index) => Obx(
                      () => GestureDetector(
                        onTap: () {
                          audioPlayerController.selectedIndex.value = index;
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color:
                                    audioPlayerController.selectedIndex.value ==
                                            index
                                        ? Colors.black54
                                        : Colors.transparent,
                                width: 2),
                          ),
                          child: Center(
                            child: Text(
                              audioPlayerController.audioTitle[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SfSlider.vertical(
                        min: 0,
                        max: 1,
                        value: _value,
                        interval: 20,
                        enableTooltip: true,
                        thumbIcon: Icon(Icons.add_alarm_rounded),
                        minorTicksPerInterval: 10,
                        onChanged: (dynamic value) {
                          setState(() {
                            _value = value;
                            volume1(_value);
                          });
                        },
                      ),
                      SfSlider.vertical(
                        min: 0,
                        max: 1,
                        value: _value2,
                        interval: 20,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        onChanged: (dynamic value) {
                          setState(() {
                            _value2 = value;
                            volume2(_value2);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    audioPlayerController.getMixUpAudio.value =
                        await get(audioPlayerController.getMixUpAudio);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordedAudio(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 50,
                    width: 200,
                    child: const Center(
                      child: Text(
                        "View Your Record",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    volume1(_value);
                    volume2(_value2);
                    audioPlayerController.mixUpAudio.add(
                      PostModel(
                          name: "index",
                          audio1: "epic.mp3",
                          volume1: _value,
                          audio2: "drum.mp3",
                          volume2: _value2),
                    );
                    save(audioPlayerController.mixUpAudio.value);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 50,
                    width: 200,
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    volume1(_value);
                    volume2(_value2);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 50,
                    width: 200,
                    child: const Center(
                      child: Text(
                        "Play",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await player.stop();
                    await player1.stop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 50,
                    width: 200,
                    child: const Center(
                      child: Text(
                        "Stop",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                _customHandler()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save(List<PostModel> persons) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> personsEncoded =
        persons.map((person) => jsonEncode(person.toJson())).toList();
    await sharedPreferences.setStringList('persons', personsEncoded);
  }

  get(List<PostModel> persons) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var json = sharedPreferences.getStringList('persons') ?? [];
    return json.map((json) => PostModel.fromJson(json)).toList();
  }

  double _lv2 = 3000.0;
  double _uv2 = 17000.0;

  _customHandler() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: const Text('Range Slider - Custom Handler'),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: FlutterSlider(
                  values: [_lv2, _uv2],
                  rangeSlider: true,
                  max: 25000,
                  min: 0,
                  step: const FlutterSliderStep(step: 100),
                  jump: true,
                  trackBar: const FlutterSliderTrackBar(
                    inactiveTrackBarHeight: 2,
                    activeTrackBarHeight: 3,
                  ),
                  disabled: false,
                  handler: customHandler(Icons.chevron_right),
                  rightHandler: customHandler(Icons.chevron_left),
                  tooltip: FlutterSliderTooltip(
                    leftPrefix: const Icon(
                      Icons.attach_money,
                      size: 19,
                      color: Colors.black45,
                    ),
                    rightSuffix: const Icon(
                      Icons.attach_money,
                      size: 19,
                      color: Colors.black45,
                    ),
                    textStyle: const TextStyle(fontSize: 17, color: Colors.black45),
                  ),
                  onDragging: (_handlerIndex, _lowerValue, _upperValue) {
                    setState(() {
                      _lv2 = _lowerValue;
                      _uv2 = _upperValue;
                    });
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                child: Text(
                  _lv2.toInt().toString() + ' - ' + _uv2.toInt().toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlutterSliderHandler customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: const BoxDecoration(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), spreadRadius: 0.05, blurRadius: 5, offset: const Offset(0, 1))],
        ),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
      ),
    );
  }


}
