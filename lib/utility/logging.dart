import 'package:logging/logging.dart';

void setupLogging() {
  Logger.root.level = Level.ALL; // Set the log level as per your preference
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}