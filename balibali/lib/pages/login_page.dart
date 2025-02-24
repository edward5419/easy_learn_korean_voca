import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/account_info_cont.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AccountInfoCont accountinfoCont = Get.put(AccountInfoCont());
  bool isRegistered = false;
  final isLoading = RxBool(false);
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  //final Box _boxLoginPage = Hive.box("login");
  //final Box _boxAccounts = Hive.box("accounts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          loginForm(context),
          Obx(
            () => isLoading.value
                ? Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 150),
            Text(
              "欢迎光临",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "登录",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 60),
            idForm(),
            const SizedBox(height: 10),
            passwordForm(),
            const SizedBox(height: 60),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (_controllerUsername.text.isEmpty ||
                        _controllerPassword.text.isEmpty) {
                      _formKey.currentState?.validate();
                      return;
                    }
                    try {
                      isLoading.value = true;
                      bool result = await accountinfoCont.login(
                          _controllerUsername.text, _controllerPassword.text);
                      isRegistered = result;
                      //print('첫번째 ${isRegistered}');

                      if (!isRegistered) {
                        //print('로그인 실패/${isRegistered}}');
                      } else {
                        //print('로그인 성공');
                        Get.offNamed('/homepage');
                      }

                      print('마지막 ${_formKey.currentState?.validate()}+');
                      isLoading.value = false;
                    } catch (error) {
                      print("Error occurred: $error");
                    }
                  },
                  child: const Text("Login"),
                ),
                //로그인 누를시 실행
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "没有账户吗？",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        _formKey.currentState?.reset();

                        Get.to(() => const Signup());
                      },
                      child: Text("注册",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField passwordForm() {
    return TextFormField(
      controller: _controllerPassword,
      focusNode: _focusNodePassword,
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            icon: _obscurePassword
                ? const Icon(Icons.visibility_outlined)
                : const Icon(Icons.visibility_off_outlined)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter username.";
        } else if (!isRegistered) {
          return "or wrong password";
        } else {
          return null;
        }
      },
    );
  }

  TextFormField idForm() {
    return TextFormField(
      controller: _controllerUsername,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onEditingComplete: () => _focusNodePassword.requestFocus(),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter username.";
        } else if (!isRegistered) {
          return "Username is not registered.";
        } else {
          return null;
        }
        //user네임이 없으면
      },
    );
  }

  Future<void> checkIdValid() async {
    try {
      bool result = await accountinfoCont.login(
          _controllerUsername.text, _controllerPassword.text);
      isRegistered = result;
      print('첫번째 $isRegistered');

      if (!isRegistered) {
        print('로그인 실패/$isRegistered}');
      } else {
        print('로그인 성공');
        Get.offNamed('/homepage');
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
