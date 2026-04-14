import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'YOURAPIKEY', obfuscate: true)
  static String mapsApiKey = _Env.mapsApiKey;
}
