import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:toastification/toastification.dart';

class RecordingController extends GetxController {
  static RecordingController get instance => Get.find();

  var isRecording = false.obs; // Observable for recording state
  var isPlaying = false.obs; // Observable for playing state
  var audioPath = RxnString(); // Stores the recorded audio file path

  late final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    _audioRecorder = AudioRecorder();
    super.onInit();

    _audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false; // Reset state when audio finishes playing
    });
  }

  @override
  void onClose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }

  // Generate a random file name for recording
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Start recording
  Future<void> startRecording() async {
    try {
      String filePath = await getApplicationDocumentsDirectory().then(
        (dir) => '${dir.path}/${_generateRandomId()}.wav',
      );

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav, echoCancel: true,
          bitRate: 32000, // Reduce bit rate (lower = lower quality)
          sampleRate: 22050, // Lower sample rate (16k or 22.05k)
          numChannels: 1, // Mono audio (saves space)
        ),
        path: filePath,
      );

      isRecording.value = true;
    } catch (e) {
      debugPrint('Error while recording: $e');
    }
  }

  // Stop recording
  Future<void> stopRecording(BuildContext context) async {
    try {
      String? path = await _audioRecorder.stop();
      if (path != null) {
        audioPath.value = path;
        AddWormsController.instance.audioRecordingPath.value = path;
        debugPrint("Recorded Path: $path");
      }
      if (context.mounted) {
        showRecordingToast(context);
      }

      isRecording.value = false;
    } catch (e) {
      debugPrint('Error while stopping recording: $e');
    }
  }

  // Handle recording toggle
  Future<void> toggleRecording(BuildContext context) async {
    if (!isRecording.value) {
      final status = await Permission.microphone.request();
      if (status == PermissionStatus.granted) {
        await startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      }
    } else {
      await stopRecording(context);
    }
  }

  // Play recorded audio
  Future<void> playRecording(BuildContext context) async {
    if (audioPath.value != null) {
      isPlaying.value = true;

      await _audioPlayer.play(DeviceFileSource(audioPath.value!));
    }
  }

  // Stop playing audio
  Future<void> stopPlaying() async {
    if (audioPath.value != null) {
      isPlaying.value = false;
      await _audioPlayer.pause();
    }
  }

  // Delete recorded audio
  Future<void> deleteRecording() async {
    if (audioPath.value != null) {
      try {
        final file = File(audioPath.value!);
        if (await file.exists()) {
          await file.delete();
          audioPath.value = null;
          isPlaying.value = false;
          isRecording.value = false;
          AddWormsController.instance.audioRecordingPath.value = "";
        }
      } catch (e) {
        debugPrint('Error while deleting recording: $e');
      }
    }
  }

  // Select an audio file from storage
  Future<void> selectAudioFromFile({required BuildContext context}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'wav',
        'aac',
        'flac',
        'm4a',
        'ogg',
        'opus',
        'wma'
      ],
    );

    if (result != null && result.files.single.path != null) {
      audioPath.value = result.files.single.path;
      AddWormsController.instance.audioRecordingPath.value =
          result.files.single.path ?? "";
      if (context.mounted) {
        showRecordingToast(context);
      }
    }
  }

  void showRecordingToast(BuildContext context) {
    showCommonToast(
        context: context,
        type: ToastificationType.success,
        title: "Recording Saved",
        description: "Your recording has been successfully saved");
  }
}
