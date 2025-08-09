
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'Beer Buddy',
            theme: ThemeData.dark().copyWith(
              primaryColor: Colors.orangeAccent,
              scaffoldBackgroundColor: Colors.black,
            ),
            home: auth.isAuthenticated ? HomeScreen() : LoginScreen(),
            routes: {
              ProfileScreen.routeName: (_) => ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
