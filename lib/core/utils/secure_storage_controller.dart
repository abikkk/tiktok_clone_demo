import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageController {
  FlutterSecureStorage secureStorageController = FlutterSecureStorage();

  // read from local storage
  Future<String?> read({required String id}) {
    return secureStorageController.read(key: id);
  }

  // write to local storage
  save({required String id, required String text}) {
    secureStorageController.write(value: text, key: id);
  }

  // delete from local storage
  delete({required String id}) {
    secureStorageController.delete(key: id);
  }

  // delete all data of local storage
  clearAll({required String id}) {
    secureStorageController.deleteAll();
  }
}
