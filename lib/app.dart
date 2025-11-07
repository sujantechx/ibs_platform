import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// Import your existing BLoCs, Repos, and Theme
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/cubit/theme_state.dart';
import 'core/theme/theme_manager.dart';



// Import your NEW Main Router
import 'core/routes/app_router.dart';
import 'courses/data/repositories/admin_repository.dart';
import 'courses/data/repositories/auth_repository.dart';
import 'courses/logic/Courses/courses_cubit.dart';
import 'courses/logic/auth/admin_cubit.dart';
import 'courses/logic/auth/auth_bloc.dart';
import 'courses/logic/test/question_cubit.dart';
import 'courses/logic/test/quiz_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- All Repositories and Blocs are created here ---
    final authRepository = AuthRepository(
      deviceInfo: DeviceInfoPlugin(),
      uuid: const Uuid(),
    );

    final authCubit = AuthCubit(authRepository: authRepository);
    final adminCubit = AdminCubit(authRepository: authRepository);
    final themeCubit = ThemeCubit();

    // MultiProvider makes all BLoCs available to all routes
    return MultiProvider(
      providers: [
        // --- REPOSITORIES ---
        Provider<AuthRepository>.value(value: authRepository),
        Provider<AdminRepository>(
          create: (_) => AdminRepository(),
        ),

        // --- BLOCS / CUBITS ---
        BlocProvider(create: (context) => authCubit..init()),
        BlocProvider(create: (context) => adminCubit),
        BlocProvider(create: (context) => themeCubit),

        BlocProvider<CoursesCubit>(
          create: (context) => CoursesCubit(
            adminRepository: context.read<AdminRepository>(),
          ),
        ),
        BlocProvider<QuestionCubit>(
          create: (context) => QuestionCubit(
            context.read<AdminRepository>(),
          ),
        ),
        BlocProvider<QuizCubit>(
          create: (context) => QuizCubit(
            context.read<AdminRepository>(),
            context.read<AuthCubit>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'IBS Platform',
            theme: ThemeManager.light,
            darkTheme: ThemeManager.dark,
            themeMode: state?.themeMode,
            debugShowCheckedModeBanner: false,

            // --- USE THE NEW MAIN ROUTER ---
            routerConfig: AppRouter(authCubit: authCubit).router,
          );
        },
      ),
    );
  }
}