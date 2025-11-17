import 'package:flutter/material.dart';
import 'core/services/theme_service.dart';
import 'features/home/presentation/pages/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeService.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _themeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String fontInter = 'Inter';
    final textThemeLight = ThemeData.light().textTheme.apply(fontFamily: fontInter);
    final textThemeDark = ThemeData.dark().textTheme.apply(fontFamily: fontInter);

    return MaterialApp(
      title: 'Rastreio PNZ',
      debugShowCheckedModeBanner: false,
      
      /// ========================================
      /// TEMA CLARO (LIGHT MODE)
      /// ========================================
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: fontInter, // Fonte padrão
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade700,
          secondary: Colors.teal.shade400,
          surface: Colors.white,
          background: Colors.grey.shade100, // Fundo levemente cinza
          onSurface: Colors.black87, // Cor de texto principal
          onBackground: Colors.black87, // Cor de texto principal
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: textThemeLight.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0.5,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        textTheme: textThemeLight,
        primaryTextTheme: textThemeLight,
        // Adiciona nossas cores customizadas ao tema
        extensions: const <ThemeExtension<dynamic>>[
          lightGradeColors,
        ],
      ),

      /// ========================================
      /// TEMA ESCURO (DARK MODE)
      /// ========================================
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: fontInter, // Fonte padrão
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade300,
          secondary: Colors.teal.shade300,
          surface: Colors.grey.shade800, // Cor de card
          background: Colors.grey.shade900, // Fundo
          onSurface: Colors.white, // Cor de texto principal
          onBackground: Colors.white, // Cor de texto principal
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: textThemeDark.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        cardTheme: CardThemeData(
          color: Colors.grey.shade800,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade700, width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
        ),
        textTheme: textThemeDark,
        primaryTextTheme: textThemeDark,
        extensions: const <ThemeExtension<dynamic>>[
          darkGradeColors,
        ],
      ),

      /// ========================================
      /// MODO DE TEMA ATUAL
      themeMode: _themeService.themeMode,

      /// ========================================
      /// PÁGINA INICIAL
      home: HomePage(themeService: _themeService),
    );
  }
}

/// ======================================================
/// DEFINIÇÃO DAS CORES CUSTOMIZADAS (ThemeExtension)
@immutable
class GradeColors extends ThemeExtension<GradeColors> {
  const GradeColors({
    required this.gradeA,
    required this.gradeASoft,
    required this.gradeB,
    required this.gradeBSoft,
    required this.gradeC,
    required this.gradeCSoft,
    required this.gradeD,
    required this.gradeDSoft,
    required this.gradeI,
    required this.gradeISoft,
  });

  final Color gradeA;
  final Color gradeASoft;
  final Color gradeB;
  final Color gradeBSoft;
  final Color gradeC;
  final Color gradeCSoft;
  final Color gradeD;
  final Color gradeDSoft;
  final Color gradeI;
  final Color gradeISoft;

  @override
  GradeColors copyWith({
    Color? gradeA, Color? gradeASoft,
    Color? gradeB, Color? gradeBSoft,
    Color? gradeC, Color? gradeCSoft,
    Color? gradeD, Color? gradeDSoft,
    Color? gradeI, Color? gradeISoft,
  }) {
    return GradeColors(
      gradeA: gradeA ?? this.gradeA,
      gradeASoft: gradeASoft ?? this.gradeASoft,
      gradeB: gradeB ?? this.gradeB,
      gradeBSoft: gradeBSoft ?? this.gradeBSoft,
      gradeC: gradeC ?? this.gradeC,
      gradeCSoft: gradeCSoft ?? this.gradeCSoft,
      gradeD: gradeD ?? this.gradeD,
      gradeDSoft: gradeDSoft ?? this.gradeDSoft,
      gradeI: gradeI ?? this.gradeI,
      gradeISoft: gradeISoft ?? this.gradeISoft,
    );
  }

  @override
  GradeColors lerp(ThemeExtension<GradeColors>? other, double t) {
    if (other is! GradeColors) {
      return this;
    }
    return GradeColors(
      gradeA: Color.lerp(gradeA, other.gradeA, t)!,
      gradeASoft: Color.lerp(gradeASoft, other.gradeASoft, t)!,
      gradeB: Color.lerp(gradeB, other.gradeB, t)!,
      gradeBSoft: Color.lerp(gradeBSoft, other.gradeBSoft, t)!,
      gradeC: Color.lerp(gradeC, other.gradeC, t)!,
      gradeCSoft: Color.lerp(gradeCSoft, other.gradeCSoft, t)!,
      gradeD: Color.lerp(gradeD, other.gradeD, t)!,
      gradeDSoft: Color.lerp(gradeDSoft, other.gradeDSoft, t)!,
      gradeI: Color.lerp(gradeI, other.gradeI, t)!,
      gradeISoft: Color.lerp(gradeISoft, other.gradeISoft, t)!,
    );
  }
}

// ---- NOSSAS CORES (MODO CLARO) ----
const lightGradeColors = GradeColors(
  gradeA: Color(0xFF22C55E),
  gradeASoft: Color(0xFFF0FDF4), 
  gradeB: Color(0xFFF59E0B), 
  gradeBSoft: Color(0xFFFFFBEB), 
  gradeC: Color(0xFFEAB308), 
  gradeCSoft: Color(0xFFFFFBEB), 
  gradeD: Color(0xFFEF4444), 
  gradeDSoft: Color(0xFFFEF2F2), 
  gradeI: Color(0xFF9CA3AF), 
  gradeISoft: Color(0xFFF9FAFB), 
);

// ---- NOSSAS CORES (MODO ESCURO - "MAIS FRACAS") ----
const darkGradeColors = GradeColors(
  gradeA: Color(0xFF166534), 
  gradeASoft: Color(0xFF1F2937), 
  gradeB: Color(0xFF92400E), 
  gradeBSoft: Color(0xFF1F2937),
  gradeC: Color(0xFF854D0E), 
  gradeCSoft: Color(0xFF1F2937),
  gradeD: Color(0xFF991B1B), 
  gradeDSoft: Color(0xFF1F2937),
  gradeI: Color(0xFF374151), 
  gradeISoft: Color(0xFF1F2937),
);