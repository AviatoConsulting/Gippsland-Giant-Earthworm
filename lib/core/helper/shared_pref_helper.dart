import 'package:get_storage/get_storage.dart';

class GetStorageHelper {
  factory GetStorageHelper() => GetStorageHelper._internal();
  GetStorageHelper._internal();

  static final GetStorage _box = GetStorage();

  // Initialize storage
  Future<void> init() async {
    await GetStorage.init();
  }

  // Remove a key
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  // Clear all storage
  Future<void> clear() async {
    await _box.erase();
  }

  // Store key-value pair
  Future<void> storeData(String key, String value) async {
    await _box.write(key, value);
  }

  // Get value
  String? getData(String key) {
    return _box.read<String>(key);
  }

  // Store boolean value
  Future<void> storeBool(String key, bool value) async {
    await _box.write(key, value);
  }

  // Get boolean value
  bool? getBool(String key) {
    return _box.read<bool>(key);
  }
}
