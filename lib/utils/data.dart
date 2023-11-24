import 'package:uuid/uuid.dart';

class DataUtils {
  static String makeUUID() {
    return const Uuid().v1();
  }
}
