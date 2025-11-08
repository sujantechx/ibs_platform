import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;
import '../../data/models/chapter_model.dart';
import '../../data/models/courses_moddel.dart';
import '../../data/models/question_model.dart';
import '../../data/models/subject_model.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';
import '../../presentation/screens/Courses/course_detail_page.dart';
import '../../presentation/screens/Courses/manage_courses_screen.dart';
import '../../presentation/screens/Courses/public_courses_screen.dart';
import '../../presentation/screens/Courses/qr_payment_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart';
import '../../presentation/screens/admin/admin_chapters_page.dart';
import '../../presentation/screens/admin/admin_content_page.dart';
import '../../presentation/screens/admin/admin_subjects_page.dart';
import '../../presentation/screens/admin/manage_question.dart';
import '../../presentation/screens/admin/manage_students_screen.dart';
import '../../presentation/screens/auth/approval_pending_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/dashboard/student_dashboard_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/puran/chapter_content_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/student/chapter_pdf.dart';
import '../../presentation/screens/student/chapters_list_screen.dart';
import '../../presentation/screens/student/pdf_list_screen.dart';
import '../../presentation/screens/student/pdf_vewer_screen.dart';
import '../../presentation/screens/student/subject_pdf.dart';
import '../../presentation/screens/student/subjects_list_screen.dart';
import '../../presentation/screens/student/test_chapter.dart';
import '../../presentation/screens/student/test_results.dart';
import '../../presentation/screens/student/test_screen.dart';
import '../../presentation/screens/student/test_subjects.dart';
import '../../presentation/screens/student/video_list_screen.dart';
import '../../presentation/widgets/video_player_widget.dart';
import '../enums/screen_mode.dart';
import 'app_routes.dart';
import '../../presentation/screens/all_list_home/all_lis_home.dart';
import '../../presentation/screens/puran/puran_list_screen.dart';
import '../../presentation/screens/puran/subject_list_screen.dart';
import '../../presentation/screens/puran/chapter_list_screen.dart';
import '../../presentation/screens/calendar/calendar_screen.dart';
import '../../presentation/screens/japa_counter/japa_counter_screen.dart';
import '../../presentation/screens/song/song_screen.dart';

class AppRouter {
  final AuthCubit authCubit;
  late final GoRouter router;

  AppRouter({required this.authCubit}) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      routes: [
        GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
        GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
        GoRoute(path: AppRoutes.register, builder: (context, state) {
          final courseId = state.extra as String? ?? '';
          return RegisterScreen(courseId: courseId);
        }),
        GoRoute(
          path: AppRoutes.courseDetail,
          builder: (context, state) {
            final course = state.extra as CoursesModel;
            return CourseDetailPage(course: course);
          },
        ),
        GoRoute(
          path: AppRoutes.qrPayment,
          builder: (context, state) {
            final course = state.extra as CoursesModel;
            return QrPaymentScreen(course: course);
          },
        ),
        GoRoute(
          path: AppRoutes.publicCourses,
          builder: (context, state) => const PublicCoursesScreen(),
        ),
        GoRoute(path: AppRoutes.all_list_home, builder: (context, state) => const AllListHome()),
        GoRoute(path: AppRoutes.puranList, builder: (context, state) => const PuranListScreen()),
        GoRoute(
          path: AppRoutes.puranSubjects,
          builder: (context, state) {
            final puranId = state.pathParameters['puranId']!;
            return SubjectListScreen(puranId: puranId);
          },
        ),
        GoRoute(
          path: AppRoutes.puranChapters,
          builder: (context, state) {
            final puranId = state.pathParameters['puranId']!;
            final subjectId = state.pathParameters['subjectId']!;
            return ChapterListScreen(puranId: puranId, subjectId: subjectId);
          },
        ),
        GoRoute(
          path: AppRoutes.puranChapterContent,
          builder: (context, state) {
            final puranId = state.pathParameters['puranId']!;
            final subjectId = state.pathParameters['subjectId']!;
            final chapterId = state.pathParameters['chapterId']!;
            return ChapterContentScreen(
              puranId: puranId,
              subjectId: subjectId,
              chapterId: chapterId,
            );
          },
        ),
        GoRoute(path: AppRoutes.calendar, builder: (context, state) => const CalendarScreen()),
        GoRoute(path: AppRoutes.japaCounter, builder: (context, state) => const JapaCounterScreen()),
        GoRoute(path: AppRoutes.song, builder: (context, state) => const SongScreen()),
        GoRoute(path: AppRoutes.pendingApproval, builder: (context, state) => const PendingApprovalScreen()),
        GoRoute(path: AppRoutes.adminDashboard, builder: (context, state) => const AdminDashboardScreen()),
        GoRoute(path: AppRoutes.manageStudents, builder: (context, state) => const ManageStudentsScreen()),

        GoRoute(
          path: AppRoutes.manageCourses,
          builder: (context, state) => const ManageCoursesScreen(),
        ),
        GoRoute(
          path: AppRoutes.AdminSubjects,
          builder: (context, state) {
            final courseId = state.extra as String;
            return AdminSubjectsPage(courseId: courseId);
          },
        ),
        GoRoute(
          path: AppRoutes.adminContent,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final courseId = data['courseId'] as String;
            final subject = data['subject'] as SubjectModel;
            final chapter = data['chapter'] as ChapterModel;

            return AdminContentPage(courseId: courseId, subject: subject, chapter: chapter);
          },
        ),
        GoRoute(
          path: AppRoutes.AdminChapters,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final courseId = data['courseId'] as String;
            final subject = data['subject'] as SubjectModel;
            return AdminChaptersPage(courseId: courseId, subject: subject);
          },
        ),
        GoRoute(
          path: AppRoutes.pdfList,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final subject = data['subject'] as SubjectModel;
            final chapter = data['chapter'] as ChapterModel;
            final coursesId= data['courseId'] as String;
            return PdfListScreen(subject: subject, chapter: chapter, courseId: coursesId,);
          },
        ),
        GoRoute(
          path: AppRoutes.chaptersList,
          builder: (context, state) {
            // Correctly cast the extra object as a Map
            final extra = state.extra as Map<String, dynamic>;
            final subject = extra['subject'] as SubjectModel;
            final courseId = extra['courseId'] as String;
            return ChaptersListScreen(subject: subject, courseId: courseId);
          },
        ),
        GoRoute(
          path: AppRoutes.chapterPDF,
          builder: (context, state) {
           final extra=state.extra as Map<String,dynamic>;
           final subject=extra['subject'] as SubjectModel;
           final courseId=extra['courseId'] as String;
            return ChapterPdf(subject: subject,courseId: courseId);
          },
        ),

        GoRoute(
          path: AppRoutes.videosList,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final subject = data['subject'] as SubjectModel;
            final chapter = data['chapter'] as ChapterModel;
            final coursesId= data['courseId'] as String;
            return VideosListScreen(subject: subject, chapter: chapter, courseId: coursesId);
          },
        ),
        GoRoute(path: AppRoutes.managesQuestions,
        builder: (context,state){
          final courseId=state.extra as String;
          final subjectId=state.extra as String;
          final chapterId=state.extra as String;
          if(courseId.isNotEmpty && subjectId.isNotEmpty && chapterId.isNotEmpty){
            return ManageQuestion(courseId: courseId, subjectId: subjectId, chapterId: chapterId,);
          }
         return ManageQuestion(courseId: courseId, subjectId: subjectId, chapterId: chapterId,);
        }
        ),
        GoRoute(
          path: '${AppRoutes.videoPlayer}/:videoId',
          builder: (context, state) {
            final videoId = state.pathParameters['videoId']!;
            return VideoPlayerScreen(videoId: videoId, mode: ScreenMode.student);
          },
        ),
        GoRoute(
          path: '${AppRoutes.adminVideoPlayer}/:videoId',
          builder: (context, state) {
            final videoId = state.pathParameters['videoId']!;
            return VideoPlayerScreen(videoId: videoId, mode: ScreenMode.admin);
          },
        ),
        GoRoute(
          path: AppRoutes.pdfViewer,
          builder: (context, state) {
            final url = state.extra as String;
            return PdfViewerScreen(url: url);
          },
        ),
        GoRoute(
          path: AppRoutes.adminPdfViewer,
          builder: (context, state) {
            final url = state.extra as String;
            return PdfViewerScreen(url: url);
          },
        ),

// lib/core/routes/app_routes.dart
// ... other routes ...

        GoRoute(
          path: '/testChapter',
          name: AppRoutes.testChapter, // Name the parent route
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final subject = data['subject'] as SubjectModel;
            final courseId = data['courseId'] as String;
            return TestChapter(subject: subject, courseId: courseId);
          },
          routes: [
            GoRoute(
              path: '/testScreen', // ✅ Correct: This is a relative path
              name: AppRoutes.testScreen, // Name the nested route
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                final subject = data['subject'] as SubjectModel; // Needs to be passed
                final courseId = data['courseId'] as String;
                final chapter = data['chapter'] as ChapterModel;
                return TestScreen(
                  courseId: courseId,
                  subjectId: subject.id,
                  chapter: chapter,
                );
              },
            ),
            GoRoute(
              path: '/quizResult', // ✅ Correct: This is a relative path
              name: AppRoutes.quizResult, // Name the nested route
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                final result = data['result'];
                final questions = data['questions'] as List<QuestionModel>;
                final courseId = data['courseId'] as String;
                final subjectId = data['subjectId'] as String;
                final chapterId = data['chapterId'] as String;
                return QuizResultScreen(
                  result: result,
                  questions: questions,
                  courseId: courseId,
                  subjectId: subjectId,
                  chapterId: chapterId,
                );
              },
            ),
          ],
        ),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return DashboardShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutes.subjectsList, builder: (context, state) => const SubjectsListScreen()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutes.subjectPDF, builder: (context, state) => const SubjectPdf()),
              ],
            ),
            StatefulShellBranch(routes: [
             GoRoute(path: AppRoutes.testSubject,builder: (context,state)=> const TestSubjects()),
            ]),
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final authState = authCubit.state;
        final currentLocation = state.matchedLocation;
        developer.log('Redirect check: authState=$authState, currentLocation=$currentLocation');

        // A list of routes that do not require authentication.
        final isPublicRoute = currentLocation == AppRoutes.publicCourses ||
            currentLocation == AppRoutes.courseDetail ||
            currentLocation == AppRoutes.qrPayment ||
            currentLocation == AppRoutes.login ||
            currentLocation == AppRoutes.register ||
            currentLocation == AppRoutes.all_list_home ||
            currentLocation == AppRoutes.puranList ||
            currentLocation == AppRoutes.calendar ||
            currentLocation == AppRoutes.japaCounter ||
            currentLocation == AppRoutes.song ||
            currentLocation.startsWith('/puran') ||
            currentLocation.startsWith('/publicCourses');

        // --- 1. Handle Initial and Loading States ---
        if (authState is AuthInitial || authState is AuthLoading) {
          if (isPublicRoute) {
            return null;
          }
          return AppRoutes.splash;
        }

        // --- 2. Handle Unauthenticated State ---
        if (authState is Unauthenticated) {
          if (authState.pendingApproval) {
            return currentLocation != AppRoutes.pendingApproval ? AppRoutes.pendingApproval : null;
          }
          return isPublicRoute ? null : AppRoutes.all_list_home;
        }

        // --- 3. Handle Authenticated State ---
        if (authState is Authenticated) {
          final user = authState.userModel;
          developer.log('Authenticated user: role=${user.role}, status=${user.status}');

          if (user.status != 'approved') {
            return currentLocation != AppRoutes.pendingApproval ? AppRoutes.pendingApproval : null;
          }

          if (user.role == 'admin') {
            final isAdminRoute = currentLocation.startsWith(AppRoutes.adminDashboard) ||
                currentLocation.startsWith(AppRoutes.manageStudents) ||
                currentLocation.startsWith(AppRoutes.manageCourses) ||
                currentLocation.startsWith(AppRoutes.AdminSubjects) ||
                currentLocation.startsWith(AppRoutes.AdminChapters) ||
                currentLocation.startsWith(AppRoutes.adminContent) ||
                currentLocation.startsWith(AppRoutes.adminVideoPlayer) ||
                currentLocation.startsWith(AppRoutes.adminPdfViewer);

            if (!isAdminRoute) {
              return AppRoutes.adminDashboard;
            }
          } else { // User is a 'student'
            final isStudentRoute = currentLocation.startsWith(AppRoutes.subjectsList) ||
                currentLocation.startsWith(AppRoutes.subjectPDF) ||
                currentLocation.startsWith(AppRoutes.profile) ||
                currentLocation.startsWith(AppRoutes.chaptersList) ||
                currentLocation.startsWith(AppRoutes.chapterPDF) ||
                currentLocation.startsWith(AppRoutes.pdfList) ||
                currentLocation.startsWith(AppRoutes.videosList) ||
                currentLocation.startsWith(AppRoutes.videoPlayer) ||
                currentLocation.startsWith(AppRoutes.pdfViewer)||
                currentLocation.startsWith(AppRoutes.testScreen)||
                currentLocation.startsWith(AppRoutes.testChapter)||
                currentLocation.startsWith(AppRoutes.testSubject);

            if (!isStudentRoute) {
              return AppRoutes.subjectsList;
            }
          }
        }
        developer.log('No redirect needed');
        return null;
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      developer.log('AuthCubit stream event: $event');
      notifyListeners();
    });
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/*
import 'dart:async';
import 'package:eduzon/data/models/courses_moddel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;
import '../../data/models/chapter_model.dart';
import '../../data/models/pdf_model.dart';
import '../../data/models/subject_model.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';
import '../../presentation/screens/Courses/course_detail_page.dart';
import '../../presentation/screens/Courses/manage_courses_screen.dart';
import '../../presentation/screens/Courses/public_courses_screen.dart';
import '../../presentation/screens/Courses/qr_payment_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart';
import '../../presentation/screens/admin/admin_chapters_page.dart';
import '../../presentation/screens/admin/admin_content_page.dart';
import '../../presentation/screens/admin/admin_subjects_page.dart';
import '../../presentation/screens/admin/manage_students_screen.dart';
import '../../presentation/screens/auth/approval_pending_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/dashboard/student_dashboard_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/student/chapter_pdf.dart';
import '../../presentation/screens/student/chapters_list_screen.dart';
import '../../presentation/screens/student/video_list_screen.dart';
import '../../presentation/widgets/video_player_widget.dart';
import '../enums/screen_mode.dart';
import 'app_routes.dart';

class AppRouter {
  final AuthCubit authCubit;
  late final GoRouter router;

  AppRouter({required this.authCubit}) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      routes: [
        GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
        GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),

        GoRoute(path: AppRoutes.register, builder: (context, state) {
          // Read the courseId string passed via the 'extra' parameter.
          final courseId = state.extra as String? ?? '';
          return RegisterScreen(courseId: courseId);
        } ),
        GoRoute(path: AppRoutes.pendingApproval, builder: (context, state) => const PendingApprovalScreen()),
        GoRoute(path: AppRoutes.adminDashboard, builder: (context, state) => const AdminDashboardScreen()),
        GoRoute(path: AppRoutes.manageStudents, builder: (context, state) => const ManageStudentsScreen()),

        GoRoute(
          path: AppRoutes.manageCourses,
          builder: (context, state) => const ManageCoursesScreen(),
        ),
        GoRoute(
          path: AppRoutes.AdminSubjects,
          builder: (context, state) {
            // Read the courseId string passed via the 'extra' parameter.
            final courseId = state.extra as String;
            return AdminSubjectsPage(courseId: courseId);
          },
        ),
        GoRoute(
          path: AppRoutes.adminContent,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final courseId = data['courseId'] as String;
            final subject = data['subject'] as SubjectModel;
            final chapter = data['chapter'] as ChapterModel;

            return AdminContentPage(courseId: courseId, subject: subject, chapter: chapter);
          },
        ),
        GoRoute(
          path: AppRoutes.AdminChapters,
          builder: (context, state) {
            // 1. Cast the 'extra' data to the expected Map type.
            final data = state.extra as Map<String, dynamic>;
            // 2. Extract the courseId and subject from the map.
            final courseId = data['courseId'] as String;
            final subject = data['subject'] as SubjectModel;

            // 3. Pass the data to the page widget.
            return AdminChaptersPage(courseId: courseId, subject: subject);
          },
        ),
        GoRoute(
          path: AppRoutes.chaptersList,
          builder: (context, state) {
            final subject = state.extra as SubjectModel;

            return ChaptersListScreen(subject: subject);
          },
        ), GoRoute(
          path: AppRoutes.chapterPDF,
          builder: (context, state) {
            final subject = state.extra as SubjectModel;
            return ChapterPdf(subject: subject);
          },
        ),
        GoRoute(
          path: AppRoutes.videoList,
          builder: (context, state) {
            final subject = state.extra as SubjectModel;
            return VideoListScreen(subject: subject);
          },
        ),
        // STUDENT route for the video player
        GoRoute(
          path: '${AppRoutes.videoPlayer}/:videoId',
          builder: (context, state) {
            final videoId = state.pathParameters['videoId']!;
            return VideoPlayerScreen(
              videoId: videoId,
              mode: ScreenMode.student, // Always student mode
            );
          },
        ),

// ADMIN route for the video player preview
        GoRoute(
          path: '${AppRoutes.adminVideoPlayer}/:videoId',
          builder: (context, state) {
            final videoId = state.pathParameters['videoId']!;
            return VideoPlayerScreen(
              videoId: videoId,
              mode: ScreenMode.admin, // Always admin mode
            );
          },
        ),

// STUDENT route for the PDF viewer - CORRECTED
        // STUDENT route for the PDF viewer
        GoRoute(path: AppRoutes.pdfViewer, builder: (context, state){
          final url = state.pathParameters['url']!;
          return PdfViewerScreen(url: url);
        }),
        GoRoute(
          path: '${AppRoutes.pdfViewer}/:url',
          builder: (context, state) {
            final url = state.pathParameters['url']!;
            return PdfViewerScreen(url: url); // Added route for PdfViewerScreen
          },
        ),
        // ADMIN route for the PDF viewer preview

        GoRoute(path: AppRoutes.adminPdfViewer, builder: (context, state){
          final url = state.pathParameters['url']!;
          return PdfViewerScreen(url: url);
        }),
        GoRoute(
          path: '${AppRoutes.adminPdfViewer}/:url',
          builder: (context, state) {
            final url = state.pathParameters['url']!;
            return PdfViewerScreen(url: url); // Added route for PdfViewerScreen
          },
        ),
        GoRoute(
          path: AppRoutes.courseDetail,
          builder: (context, state) {
            final course = state.extra as CoursesModel;
            return CourseDetailPage(course: course);
          },
        ),
        GoRoute(
          path: AppRoutes.qrPayment,
          builder: (context, state) {
            final course = state.extra as CoursesModel;
            return QrPaymentScreen(course: course);
          },
        ),
        GoRoute(
          path: AppRoutes.publicCourses,
          builder: (context, state) => const PublicCoursesScreen(),
        ),
        GoRoute(path: AppRoutes.home, builder: (context, state) => const AllListHome()),
        GoRoute(path: AppRoutes.puranList, builder: (context, state) => const PuranListScreen()),
        GoRoute(
          path: AppRoutes.puranSubjects,
          builder: (context, state) {
            final puranId = state.pathParameters['puranId']!;
            return SubjectListScreen(puranId: puranId);
          },
        ),
        GoRoute(
          path: AppRoutes.puranChapters,
          builder: (context, state) {
            final puranId = state.pathParameters['puranId']!;
            final subjectId = state.pathParameters['subjectId']!;
            return ChapterListScreen(puranId: puranId, subjectId: subjectId);
          },
        ),
        GoRoute(
          path: AppRoutes.puranChapterContent,
          builder: (context, state) {
            final puranId = state.pathParameters['puranId']!;
            final subjectId = state.pathParameters['subjectId']!;
            final chapterId = state.pathParameters['chapterId']!;
            return ChapterContentScreen(
              puranId: puranId,
              subjectId: subjectId,
              chapterId: chapterId,
            );
          },
        ),
        GoRoute(path: AppRoutes.calendar, builder: (context, state) => const CalendarScreen()),
        GoRoute(path: AppRoutes.japaCounter, builder: (context, state) => const JapaCounterScreen()),
        GoRoute(path: AppRoutes.song, builder: (context, state) => const SongScreen()),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return DashboardShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutes.subjectsList, builder: (context, state) => const SubjectsListScreen()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutes.subjectPDF, builder: (context, state) => const SubjectPdf()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final authState = authCubit.state;
        final currentLocation = state.matchedLocation;
        developer.log('Redirect check: authState=$authState, currentLocation=$currentLocation');

        // A list of routes that do not require authentication.
        final isPublicRoute = currentLocation == AppRoutes.publicCourses ||
            currentLocation == AppRoutes.courseDetail ||
            currentLocation == AppRoutes.qrPayment ||
            currentLocation == AppRoutes.login ||
            currentLocation == AppRoutes.register ||
            currentLocation == AppRoutes.all_list_home ||
            currentLocation == AppRoutes.puranList ||
            currentLocation == AppRoutes.calendar ||
            currentLocation == AppRoutes.japaCounter ||
            currentLocation == AppRoutes.song ||
            currentLocation.startsWith('/puran') ||
            currentLocation.startsWith('/publicCourses');

        // --- 1. Handle Initial and Loading States ---
        if (authState is AuthInitial || authState is AuthLoading) {
          if (isPublicRoute) {
            return null;
          }
          return AppRoutes.splash;
        }

        // --- 2. Handle Unauthenticated State ---
        if (authState is Unauthenticated) {
          if (authState.pendingApproval) {
            return currentLocation != AppRoutes.pendingApproval ? AppRoutes.pendingApproval : null;
          }
          return isPublicRoute ? null : AppRoutes.all_list_home;
        }

        // --- 3. Handle Authenticated State ---
        if (authState is Authenticated) {
          final user = authState.userModel;
          developer.log('Authenticated user: role=${user.role}, status=${user.status}');

          if (user.status != 'approved') {
            return currentLocation != AppRoutes.pendingApproval ? AppRoutes.pendingApproval : null;
          }

          if (user.role == 'admin') {
            final isAdminRoute = currentLocation.startsWith(AppRoutes.adminDashboard) ||
                currentLocation.startsWith(AppRoutes.manageStudents) ||
                currentLocation.startsWith(AppRoutes.manageCourses) ||
                currentLocation.startsWith(AppRoutes.AdminSubjects) ||
                currentLocation.startsWith(AppRoutes.AdminChapters) ||
                currentLocation.startsWith(AppRoutes.adminContent) ||
                currentLocation.startsWith(AppRoutes.adminVideoPlayer) ||
                currentLocation.startsWith(AppRoutes.adminPdfViewer);

            if (!isAdminRoute) {
              return AppRoutes.adminDashboard;
            }
          } else { // User is a 'student'
            final isStudentRoute = currentLocation.startsWith(AppRoutes.subjectsList) ||
                currentLocation.startsWith(AppRoutes.subjectPDF) ||
                currentLocation.startsWith(AppRoutes.profile) ||
                currentLocation.startsWith(AppRoutes.chaptersList) ||
                currentLocation.startsWith(AppRoutes.chapterPDF) ||
                currentLocation.startsWith(AppRoutes.pdfList) ||
                currentLocation.startsWith(AppRoutes.videosList) ||
                currentLocation.startsWith(AppRoutes.videoPlayer) ||
                currentLocation.startsWith(AppRoutes.pdfViewer)||
                currentLocation.startsWith(AppRoutes.testScreen)||
                currentLocation.startsWith(AppRoutes.testChapter)||
                currentLocation.startsWith(AppRoutes.testSubject);

            if (!isStudentRoute) {
              return AppRoutes.subjectsList;
            }
          }
        }
        developer.log('No redirect needed');
        return null;
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      developer.log('AuthCubit stream event: $event');
      notifyListeners();
    });
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}*/
