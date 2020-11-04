import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/services/user_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserRepository>(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text("LoginPage"),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: formKey,
          child: Center(
            //    padding: EdgeInsets.all(40),

            child: ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTextFormFieldEmail(),
                buildTextFormFieldPassword(),
                Divider(
                  color: Colors.transparent,
                ),
                userRepo.durum == userDurumu.OTURUMACILIYOR
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      )
                    : buildRaisedButtonLogin(userRepo),
                Divider(
                  color: Colors.transparent,
                ),
                Container(
                  height: 1.3 * (MediaQuery.of(context).size.height / 20),
                  width: 4 * (MediaQuery.of(context).size.width / 10),
                  child: RaisedButton(
                    child: Text("Gmail ile Giriş Yap"),
                    color: Colors.red,
                    onPressed: () async {
                      userRepo.signWithGoogle();
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  TextFormField buildTextFormFieldEmail() {
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        //     LengthLimitingTextInputFormatter(30),
        //   FilteringTextInputFormatter.deny(RegExp('[abF!.]')),
        //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
        // FilteringTextInputFormatter.deny(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")),
      ],
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        labelText: "Email",
        //border: OutlineInputBorder(),
      ),
      validator: (value) {
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);
        if (emailValid) {
          return null;
        } else {
          return "Lütfen geçerli bir Email giriniz.";
        }
        // if (value.isEmpty) {
        //   return "have a error";
        // } else {
        //   return null;
        // }
      },
    );
  }

  TextFormField buildTextFormFieldPassword() {
    return TextFormField(
      controller: _password,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        fillColor: Colors.black,
        labelText: "Password",
        //  border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value.length < 6) {
          return "minimum requred 6 or more";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildRaisedButtonLogin(UserRepository userRepo) {
    return Container(
      height: 1.3 * (MediaQuery.of(context).size.height / 20),
      width: 4 * (MediaQuery.of(context).size.width / 10),
      //   margin: EdgeInsets.only(bottom: 20, top: 20),
      child: RaisedButton(
        color: Colors.green,
        elevation: 5.0,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        child: Text("Giriş Yap",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 40,
              letterSpacing: 1.5,
            )),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            print("oke");
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("Oturum Açılıyor..."),
                duration: Duration(seconds: 1),
              ),
            );
            if (!await userRepo.signIn(_email.text.trim(), _password.text)) {
              scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text("Hata"),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          } else {
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("Lütfen Doğru Değerler Giriniz."),
              ),
            );
          }
        },
      ),
    );
  }
}
