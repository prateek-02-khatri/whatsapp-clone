import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors.dart';
import 'extension/custom_theme_extension.dart';

ThemeData lightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: const ColorScheme.light(surface: AppColors.backgroundLight),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    extensions: [
      CustomThemeExtension.lightMode
    ],

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.greenLight,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2,
        )
      ),
      unselectedLabelColor: Color(0xFFB3D9D2),
      labelColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenLight,
            foregroundColor: AppColors.backgroundLight,
            splashFactory: NoSplash.splashFactory,
            elevation: 0,
            shadowColor: Colors.transparent
        )
    ),

    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.backgroundLight,
        modalBackgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        )
    ),

    dialogBackgroundColor: AppColors.backgroundLight,
    dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        )
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.greenDark,
      foregroundColor: Colors.white,
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.greyDark,
      tileColor: AppColors.backgroundLight,
    ),

    switchTheme: const SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(Color(0xFF83939C)),
        trackColor: WidgetStatePropertyAll(Color(0xFFDADFE2))
    ),
  );
}