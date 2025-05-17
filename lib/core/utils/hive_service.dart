import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/model/worm_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static const String _boxName = 'wormsBox';

  /// Initialize Hive
  static Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path; // Get app's document directory

    Hive.init(path);
    Hive.registerAdapter(WormModelAdapter());
    await Hive.openBox<WormModel>(_boxName);
  }

  /// Save WormModel to Hive (Offline Storage)
  Future<void> saveWorm(WormModel worm) async {
    var box = Hive.box<WormModel>(_boxName);
    await box.put(worm.id, worm);
  }

  /// Get All Offline Worms
  Future<List<WormModel>> getAllWorms() async {
    var box = Hive.box<WormModel>(_boxName);
    final worms = box.values.toList();
    debugPrint("Worms: ${worms.map((e) => e.toString()).toList()}");
    return worms;
  }

  /// Get a Single Worm by ID
  Future<WormModel?> getWormById(String id) async {
    var box = Hive.box<WormModel>(_boxName);
    return box.get(id);
  }

  /// Delete a Worm from Offline Storage and remove associated files
  Future<void> deleteWorm(String id) async {
    var box = Hive.box<WormModel>(_boxName);
    WormModel? worm = box.get(id); // Get worm details before deleting

    if (worm != null) {
      try {
        debugPrint("Deleting worm with ID: $id");

        // Delete location image
        if (worm.locationImg.isNotEmpty) {
          File locationFile = File(worm.locationImg);
          if (locationFile.existsSync()) {
            locationFile.deleteSync();
            debugPrint("Deleted location image: ${worm.locationImg}");
          } else {
            debugPrint("Location image not found: ${worm.locationImg}");
          }
        }

        // Delete worm images
        for (String imagePath in worm.wormsImg) {
          File imageFile = File(imagePath);
          if (imageFile.existsSync()) {
            imageFile.deleteSync();
            debugPrint("Deleted worm image: $imagePath");
          } else {
            debugPrint("Worm image not found: $imagePath");
          }
        }

        // Delete audio file if exists
        if (worm.audioUrl.isNotEmpty) {
          File audioFile = File(worm.audioUrl);
          if (audioFile.existsSync()) {
            audioFile.deleteSync();
            debugPrint("Deleted audio file: ${worm.audioUrl}");
          } else {
            debugPrint("Audio file not found: ${worm.audioUrl}");
          }
        }
      } catch (e) {
        debugPrint("Error deleting worm files: $e");
      }
    }

    // Finally, delete worm entry from Hive
    await box.delete(id);
    debugPrint("Deleted worm from Hive storage with ID: $id");
  }

  /// Clear All Stored Worms (Use with Caution)
  /// Delete all worms and their files
  Future<void> deleteAllWorms(List<WormModel> wormList) async {
    var box = Hive.box<WormModel>(_boxName);

    for (var worm in wormList) {
      try {
        // Delete location image
        if (worm.locationImg.isNotEmpty) {
          File file = File(worm.locationImg);
          if (file.existsSync()) file.deleteSync();
        }

        // Delete all worm images
        for (var imagePath in worm.wormsImg) {
          File file = File(imagePath);
          if (file.existsSync()) file.deleteSync();
        }

        // Delete audio file
        if (worm.audioUrl.isNotEmpty) {
          File file = File(worm.audioUrl);
          if (file.existsSync()) file.deleteSync();
        }
      } catch (e) {
        debugPrint("Error deleting files for worm ${worm.id}: $e");
      }
    }

    await box.clear(); // Clear Hive storage
    wormList.clear(); // Update UI
    debugPrint("All worms deleted successfully!");
  }

  /// Check if a Worm Exists
  Future<bool> doesWormExist(String id) async {
    var box = Hive.box<WormModel>(_boxName);
    return box.containsKey(id);
  }
}
