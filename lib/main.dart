import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/screens/home_page.dart';
import 'package:kilo_analiz_uygulamasi/screens/sign_in_page.dart';
import 'package:kilo_analiz_uygulamasi/services/db.dart';
import 'package:kilo_analiz_uygulamasi/services/user_repository.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("deneme");
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<UserRepository>(
//           create: (context) => UserRepository(),
//         )
//       ],
//       child: MaterialApp(
//         title: 'Kilo Takip Takip',
//         home: HomePage(),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        // StreamProvider<User>.value(
        //     value: FirebaseAuth.instance.authStateChanges())
      ],
      child: MaterialApp(
        title: 'Kilo Takip Takip',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: buildScaffold(),
      ),
    );
  }
}

class buildScaffold extends StatelessWidget {
  const buildScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hoş Geldiniz !",
              style: Theme.of(context).textTheme.headline4,
            ),
            //crossAxisAlignment: CrossAxisAlignment.center,
            SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}