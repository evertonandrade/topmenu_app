import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get title => dotenv.get('title');
  static String get baseUrl => dotenv.get('baseUrl');
  static String get environment => dotenv.get('environment');
}

