import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../model/survey.dart';

Future<void> initHive() async {
  final dbDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dbDir.path);
  Hive.registerAdapter(SurveyAdapter());
}
