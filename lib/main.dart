import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_care/constants.dart';
import 'package:med_care/global_bloc.dart';
import 'package:med_care/pages/home_page.dart';
//import 'package:med_care/pages/new_entry/new_entry_bloc.dart';
import 'package:med_care/splash_screen.dart';
import 'package:provider/provider.dart';
//import 'pages/home_page.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


// void main() {
//   runApp(const MyApp());
// }

Future main() async{
   // WidgetsFlutterBinding.ensureInitialized();

   await Future.delayed(const Duration(seconds: 3));
   FlutterNativeSplash.remove();
   runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  GlobalBloc? globalBloc;

  @override
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc!,
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          
          title: 'Med_Care',
          //theme customiz
          theme: ThemeData.dark().copyWith(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kScaffoldColor,
            //appbar theme customiz
            appBarTheme: AppBarTheme(
              toolbarHeight: 70,
              backgroundColor: kScaffoldColor,
              elevation: 0,
              
              iconTheme: IconThemeData(
                color: kSecondaryColor,
                size: 20,
              ),
              titleTextStyle: GoogleFonts.mulish(
                color: kTextColor,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
                fontSize: 16,
              ),
               shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),  // Adjust the curve radius as needed
                  bottomRight: Radius.circular(20),  // Adjust the curve radius as needed
                ),
              ),
            ),
            textTheme: TextTheme(
              displaySmall: TextStyle(
                  fontSize: 28,
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w500),
              headlineMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: kTextColor,
              ),
              headlineSmall: TextStyle(
                fontSize: 16.sp,

                fontWeight: FontWeight.w900,
                color: kTextColor,
              ),
              titleSmall: GoogleFonts.poppins(fontSize: 15, color: kPrimaryColor),
              titleMedium: GoogleFonts.poppins(fontSize: 12, color: kTextLightColor),
              bodySmall: GoogleFonts.poppins(
                fontSize: 4.w,
                fontWeight: FontWeight.w400,
                color: kTextLightColor,
    
              ),

              
               titleLarge: GoogleFonts.poppins(
                  fontSize: 6.w,
                  color: kTextColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  ),
              labelMedium: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: kTextColor,
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kTextLightColor,
                  width: 0.9,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kTextLightColor,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
              ),
            ),
            //
            //time picker theme customiz
            timePickerTheme: TimePickerThemeData(
              backgroundColor: kScaffoldColor,
              hourMinuteColor: kTextColor,
              hourMinuteTextColor: kScaffoldColor,
              dayPeriodColor: kTextColor,
              dayPeriodTextColor: kScaffoldColor,
              dialBackgroundColor: kTextColor,
              dialHandColor: kPrimaryColor,
              dialTextColor: kScaffoldColor,
              entryModeIconColor: kOtherColor,
              dayPeriodTextStyle: GoogleFonts.aBeeZee(
                fontSize: 8.sp,
    
              ),
            ),
          ),
          home: Scaffold(
            appBar: AppBar(
              backgroundColor:kAppBarColor,
              // shadowColor: Colors.lightBlue,
              elevation: 5,
              title: Center(
                child: Text(
                  'Med_Care',
                  style: GoogleFonts.mulish(
                    color: kAppBarTextColor,
                    fontWeight: FontWeight.bold,
                    // fontStyle: FontStyle.normal,
                    fontSize: 4.w,
                  ),
                ),
              ),
            ),

            body: const HomePage(),
          ),
         // home: SplashScreen(),
        );
      }),
    );
  }
}
