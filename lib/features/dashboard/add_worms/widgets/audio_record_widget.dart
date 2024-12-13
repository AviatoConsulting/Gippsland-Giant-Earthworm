import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/recording_waves.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isRecording = false; // Tracks whether the recording is in progress
  late final AudioRecorder
      _audioRecorder; // AudioRecorder instance for recording
  String? _audioPath; // Stores the file path of the recorded audio
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // AudioPlayer instance to play recorded audio
  bool isPlaying = false; // Tracks whether the audio is currently playing

  @override
  void initState() {
    _audioRecorder = AudioRecorder(); // Initialize the audio recorder
    super.initState();

    // Set up listener for when audio finishes playing
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false; // Reset the isPlaying state once the audio finishes
      });
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose(); // Dispose the audio recorder
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  // Generate a random file name for the recorded audio file
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[
          random.nextInt(chars.length)], // Generate a random character string
      growable: false,
    ).join();
  }

  // Start recording and save the file to the device
  Future<void> _startRecording() async {
    try {
      // Define the file path where the recording will be saved
      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');

      // Start the audio recording with specified configurations (e.g., WAV format, echo cancellation)
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav, echoCancel: true),
        path: filePath,
      );
    } catch (e) {
      debugPrint(
          'ERROR WHILE RECORDING: $e'); // Print error message if something goes wrong
    }
  }

  // Stop the recording and store the file path
  Future<void> _stopRecording() async {
    try {
      // Stop recording and get the file path of the saved audio
      String? path = await _audioRecorder.stop();

      setState(() {
        _audioPath = path!; // Update the state with the audio file path
        AddWormsController.instance.audioRecordingPath.value =
            path; // Pass path to another controller
      });
      debugPrint(
          'Recorded file path: $_audioPath'); // Print the path of the recorded audio
    } catch (e) {
      debugPrint(
          'ERROR WHILE STOP RECORDING: $e'); // Print error message if something goes wrong
    }
  }

  // Handle the recording toggle (start/stop recording)
  void _record() async {
    if (isRecording == false) {
      // Request permission to access the microphone
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          isRecording = true; // Start recording if permission is granted
        });
        await _startRecording(); // Start recording the audio
      } else if (status == PermissionStatus.permanentlyDenied) {
        await openAppSettings(); // Prompt user to open app settings if permission is permanently denied
        debugPrint('Permission permanently denied');
      }
    } else {
      await _stopRecording(); // Stop recording if already recording
      setState(() {
        isRecording =
            false; // Update state to indicate that recording has stopped
      });
    }
  }

  // Play the recorded audio file
  Future<void> _playRecording() async {
    if (_audioPath != null) {
      setState(() {
        isPlaying = true; // Set isPlaying to true while the audio is playing
      });
      await _audioPlayer.play(
          DeviceFileSource(_audioPath!)); // Play the audio from the stored path
    }
  }

  // Stop playing the audio
  Future<void> _stopPlaying() async {
    if (_audioPath != null) {
      setState(() {
        isPlaying =
            false; // Update isPlaying state to false when stopping playback
      });
      await _audioPlayer.pause(); // Pause the audio playback
    }
  }

  // Delete the recorded audio file
  Future<void> _deleteRecording() async {
    if (_audioPath != null) {
      try {
        final file =
            File(_audioPath!); // Create a file object from the file path
        if (await file.exists()) {
          await file.delete(); // Delete the file from storage
          setState(() {
            _audioPath = null; // Reset the audio path after deletion
          });
          debugPrint('Recording deleted successfully.');
        }
      } catch (e) {
        debugPrint(
            'ERROR WHILE DELETING RECORDING: $e'); // Print error if deletion fails
      }
    }
  }

  // Allow the user to select an audio file from the device
  Future<void> _selectAudioFromFile() async {
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
      ], // List of supported audio formats
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioPath = result.files.single.path; // Set the selected file path
      });
      AddWormsController.instance.audioRecordingPath.value =
          _audioPath!; // Pass path to another controller
      debugPrint(
          'Selected file path: $_audioPath'); // Print the selected file path
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Button to allow the user to upload an audio file
        Align(
            alignment: Alignment.topRight,
            child: InkWell(
                onTap: _selectAudioFromFile, // Trigger file picker on tap
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      color: AppColor.primaryColor,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Upload Recording",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ],
                ))),
        const SizedBox(height: 10),
        Container(
          decoration: CommonAssets.containerGreyDecoration(),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Button for recording or deleting the audio
              InkWell(
                onTap: () {
                  if ((_audioPath != null && !isRecording)) {
                    _deleteRecording(); // Delete recording if file exists and not recording
                  } else {
                    _record(); // Start or stop recording based on the current state
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(8),
                    child: (_audioPath != null && !isRecording)
                        ? const Icon(
                            Icons.delete,
                            color: Colors.black54,
                          )
                        : isRecording
                            ? const Icon(
                                Icons.stop_circle,
                                color: Colors.black54,
                              )
                            : const Icon(
                                Icons.mic,
                                color: Colors.black54,
                              )),
              ),
              const SizedBox(width: 20),
              // Displaying recording waveform during recording, static waves otherwise
              isRecording
                  ? const CustomRecordingWaveWidget()
                  : const CustomStaticWaves(),
              if (_audioPath != null) const Spacer(),
              if (_audioPath != null)
                InkWell(
                  onTap: () {
                    if (isPlaying) {
                      _stopPlaying(); // Stop playing the audio if it's already playing
                    } else {
                      _playRecording(); // Start playing the audio
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black54,
                      )),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
