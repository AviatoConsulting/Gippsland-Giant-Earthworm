import 'package:get_storage/get_storage.dart';

final GetStorage storage = GetStorage();

class PathStorage {
  // key value storage
  static savePath(String key, String value) {
    storage.write(key, value);
  }

  // if key available then return value
  static String readPathIfAvailable(String key) {
    if (storage.hasData(key)) {
      return storage.read(key);
    } else {
      return "";
    }
  }
}
