import 'package:audio_player/post_model.dart';
import 'package:get/get.dart';

class AudioPlayerController extends GetxController {
  RxList<PostModel> mixUpAudio = <PostModel>[].obs;
  RxList<PostModel> getMixUpAudio = <PostModel>[].obs;
  RxList audioTitle = ["BIRDS", "DRUM"].obs;
  RxInt selectedIndex = 0.obs;
}
