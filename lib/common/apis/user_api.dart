// user_api.dart
import 'package:wal/common/entities/entities.dart';
import '../utils/http_util.dart';

class UserAPI {
  static Future<UserLoginResponseEntity> login({
    LoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post('api/login', mydata: params?.toJson());
    return UserLoginResponseEntity.fromJson(response);
  }

  // user_api.dart
  static Future<RegisterResponseEntity> register({
    RegisterRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/register',
      mydata: params?.toJson(),
    );
    return RegisterResponseEntity.fromJson(response);
  }
}
