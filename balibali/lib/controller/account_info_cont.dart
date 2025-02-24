import 'package:balibali/model/signup_info_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/url.dart';
import '../model/account_info_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/login_info_model.dart';

class AccountInfoCont extends GetxController {
  final accountInfo = <AccountInfoModel>[].obs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final loginUrl = Uri.parse("${UrlmetaData.url}/accounts/login");
  final autoLoginUrl = Uri.parse("${UrlmetaData.url}/accounts/autoLogin");
  final logoutUrl = Uri.parse("${UrlmetaData.url}/accounts/logout");

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<bool> fetchData() async {
    //내부저장소에서 세션 검사 시작

    final String? sessionKey = await _secureStorage.read(key: 'sessionKey');

    if (kDebugMode) {
      print('로컬 세션키 불러오기');
      print(sessionKey);
    }

    if (sessionKey != null) {
      try {
        //http 통신 시작
        if (kDebugMode) {
          print("트라이 시작 !!");
        }
        final response =
            await http.post(autoLoginUrl, headers: {'sessionKey': sessionKey});

        if (kDebugMode) print("결과 ${response.body}");

        if (response.statusCode == 200) {
          final accountInfoData = accountInfoModelFromJson(response.body);
          accountInfo.assign(accountInfoData);
          if (accountInfoData.isValid != true) {
            return false;
          }
        } else {
          final accountInfoData = AccountInfoModel(
              userId: 'none',
              sessionKey: 'none',
              email: 'none',
              isValid: false);
          accountInfo.assign(accountInfoData);
        }

        return true;
      } catch (e) {
        //http 통신 실패

        final accountInfoData = AccountInfoModel(
            userId: 'none', sessionKey: 'none', email: 'none', isValid: false);
        accountInfo.assign(accountInfoData);
        return false;
      }
    } else {
      //내부저장소에 데이터가 없으면

      final accountInfoData = AccountInfoModel(
          userId: 'none', sessionKey: 'none', email: 'none', isValid: false);
      accountInfo.assign(accountInfoData);
      return false;
    }
  }

  Future<bool> login(String userId, String password) async {
    final loginUrl = Uri.parse("${UrlmetaData.url}/accounts/login");
    final loginInfoData = LoginInfoModel(username: userId, password: password);
    final loginInfoDataJson = loginInfoModelToJson(loginInfoData);

    try {
      final response = await http.post(loginUrl, body: loginInfoDataJson);

      final accountInfoData = accountInfoModelFromJson(response.body);

      if (response.statusCode == 200) {
        if (!accountInfoData.isValid) {
          return false;
        } else {
          if (kDebugMode) print('세션키 로컬스토리지에 저장');

          saveSessionKey(accountInfoData.sessionKey);
          accountInfo.assign(accountInfoData);
          if (kDebugMode) {
            print(accountInfo[0].sessionKey);
          }
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<String> signUp(String userId, String password, String email) async {
    final signupUrl = Uri.parse("${UrlmetaData.url}/accounts/signup");
    if (kDebugMode) print("인터넷주소@@@@@@${UrlmetaData.url}/accounts/signup");
    final signUpInfoData =
        SignUpInfoModel(username: userId, password: password, email: email);
    final signUpInfoDataJson = signUpInfoModelToJson(signUpInfoData);
    if (kDebugMode) print(signUpInfoData);
    try {
      final response = await http.post(signupUrl, body: signUpInfoDataJson);

      switch (response.statusCode) {
        case 400:
          if (kDebugMode) print("결과 ${response.body}");
          return "Please provide all required fields";
        case 401:
          return "Username already exists";
        case 402:
          return "email already exists";
        case 201:
          return "Register complete";
        default:
          return "error, please contact jin xuan zhu";
      }
    } catch (e) {
      if (kDebugMode) {
        print("회원가입 실패");
      }
      return "error please contact jin xuan zhu";
    }
  }

  Future<void> saveSessionKey(String sessionKey) async {
    await _secureStorage.write(key: 'sessionKey', value: sessionKey);
    final String? sessionKey1 = await _secureStorage.read(key: 'sessionKey');
    if (kDebugMode) print(sessionKey1);
  }

  Future<void> clearAutoLogin() async {
    if (kDebugMode) print('삭제 전 확인');

    final sessionKey = accountInfo[0].sessionKey;
    if (kDebugMode) print(sessionKey);
    try {
      final response =
          await http.post(logoutUrl, headers: {'sessionKey': sessionKey});
      deleteChapterFromLocal();
      if (kDebugMode) print(response);
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> deleteChapterFromLocal() async {
    _secureStorage.delete(key: 'chapterId');
    _secureStorage.delete(key: 'chapterTopic');
    _secureStorage.delete(key: 'chapterGroup');
    _secureStorage.delete(key: 'memoDate1');
    _secureStorage.delete(key: 'memoData2');
    _secureStorage.delete(key: 'memoDate3');
    _secureStorage.delete(key: 'memoDate4');
    _secureStorage.delete(key: 'chapterMemoNum');
    _secureStorage.delete(key: 'vocaListLen');
    _secureStorage.delete(key: 'vocaListMemoLen');
  }
}
