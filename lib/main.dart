import 'package:edicion_limitada/common/utils/app_color.dart';
import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/shopping/bloc/shopping_bloc.dart';
import 'package:edicion_limitada/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>AuthBloc(AuthService())),
        BlocProvider(create: (context)=>ShoppingBloc()..add(LoadProducts())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Edicion',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
