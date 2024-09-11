
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors.dart';
import 'extension/custom_theme_extension.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: const ColorScheme.dark(surface: AppColors.backgroundDark),

    scaffoldBackgroundColor: AppColors.backgroundDark,

    extensions: [
      CustomThemeExtension.darkMode
    ],

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.greyBackground,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.greenDark,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(
        color: AppColors.greenDark
      )
    ),

    tabBarTheme: const TabBarTheme(
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: AppColors.greenDark,
              width: 2,
            )
        ),
        unselectedLabelColor: AppColors.greyDark,
        labelColor: AppColors.greenDark,
      ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenDark,
          foregroundColor: AppColors.backgroundDark,
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          shadowColor: Colors.transparent
      )
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.greyBackground,
      modalBackgroundColor: AppColors.greyBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      )
    ),

    dialogBackgroundColor: AppColors.greyBackground,

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
      tileColor: AppColors.backgroundDark,
    ),

    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.greenDark),
      trackColor: WidgetStatePropertyAll(Color(0xFF344047))
    ),
  );
}