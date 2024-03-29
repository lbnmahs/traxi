import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:traxi/data/auth/auth_data_provider.dart';
import 'package:traxi/data/auth/auth_repository.dart';
import 'package:traxi/firebase_options.dart';
import 'package:traxi/middleware/auth/bloc/auth_bloc.dart';
import 'package:traxi/views/screens/auth_screen.dart';
import 'package:traxi/views/screens/splash_screen.dart';
import 'package:traxi/views/screens/tabs.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final UserAuthDataProvider userAuthDataProvider = UserAuthDataProvider();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(userAuthDataProvider),
        ),
      ], 
      child: MultiBlocProvider(
      providers: [
        BlocProvider<UserAuthBloc>(
          create: (context) => UserAuthBloc(
            userRepository: context.read<UserRepository>(),
          )..add(CheckAuthEvent()),
        ),
      ],
      child: const MyApp(),
    ),
    )
  );
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.latoTextTheme(),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey.shade400,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traxi',
      theme: theme,
      home: MultiBlocListener(
        listeners: [
          BlocListener<UserAuthBloc, UserAuthState>(
            listener: (context, state) {
              if(state is UserAuthSuccess) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TabScreen(),
                  ),
                );
              } else if (state is UserAuthFailure) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              }
            }
          )
        ],
        child: const SplashScreen(),
      ),
    );
  }
}
