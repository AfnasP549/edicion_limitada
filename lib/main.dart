import 'package:edicion_limitada/common/utils/constatns/app_color.dart';
import 'package:edicion_limitada/features/address_management/bloc/address_bloc.dart';
import 'package:edicion_limitada/features/address_management/service/address_service.dart';
import 'package:edicion_limitada/features/auth/views/service/auth_service.dart';
import 'package:edicion_limitada/features/auth/bloc/auth_bloc.dart';
import 'package:edicion_limitada/features/cart/bloc/cart_bloc.dart';
import 'package:edicion_limitada/features/checkout/bloc/checkout_bloc.dart';
import 'package:edicion_limitada/features/checkout/service/checkou_service.dart';
import 'package:edicion_limitada/features/profile/bloc/profile_bloc.dart';
import 'package:edicion_limitada/features/shopping/bloc/shopping_bloc.dart';
import 'package:edicion_limitada/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //final walletService = WalletService();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      
      providers: [
    BlocProvider(
      create: (context) => AuthBloc(AuthService())
    ),
    BlocProvider(
      create: (context) => ShoppingBloc()..add(LoadProducts())
    ),
    BlocProvider(
      create: (context) => ProfileBloc()
    ),
  

    BlocProvider(
      create: (context) => CartBloc()
    ),
    if (FirebaseAuth.instance.currentUser != null)
      BlocProvider(
        create: (context) => AddressBloc(
          AddressService(userId: FirebaseAuth.instance.currentUser!.uid),
        )..add(LoadAddressesEvent()),
      ),
    if (FirebaseAuth.instance.currentUser != null)
      BlocProvider(
        create: (context) => CheckoutBloc(
          checkoutService: CheckoutService(),
          cartBloc: context.read<CartBloc>(),
          addressBloc: context.read<AddressBloc>(),
        ),
      ),

  ],
      child: MaterialApp(

        // themeMode: ThemeMode.system,
        // debugShowCheckedMo deBanner: false,
        // title: 'Edicion',

        // theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,


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
