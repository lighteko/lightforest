import 'dart:io';

class DBUtils {
  void createDB(String nickname) {
    var jsonStr = '{}';
    File('${nickname}_todos.json').writeAsStringSync(jsonStr);
  }
}
