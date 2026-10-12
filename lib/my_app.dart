import 'package:allo_taf/core/app_binding/app_bindings.dart';
import 'package:allo_taf/core/localization/language_translation.dart';
import 'package:allo_taf/core/service/auth_service.dart';
import 'package:allo_taf/core/utils/constants/app_colors.dart';
import 'package:allo_taf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine initial locale based on saved data
    Locale initialLocale = AuthService.language == "French"
        ? const Locale('fr', 'FR')
        : const Locale('en', 'US');
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Allo Taf',
          debugShowCheckedModeBanner: false,
          translations: LanguageTranslation(),
          locale: initialLocale,
          fallbackLocale: const Locale('fr', 'FR'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
            ),
          ),
          initialBinding: AppBindings(),
          initialRoute: AppRoutes.init,
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}
