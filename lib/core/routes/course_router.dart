import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;


import '../../core/enums/screen_mode.dart';
import '../../courses/data/models/chapter_model.dart';
import '../../courses/data/models/courses_moddel.dart';
import '../../courses/data/models/question_model.dart';
import '../../courses/data/models/subject_model.dart';
import '../../courses/logic/auth/auth_bloc.dart';
import '../../courses/logic/auth/auth_state.dart';
import '../../courses/ui/presentation/screens/Courses/course_detail_page.dart';
import '../../courses/ui/presentation/screens/Courses/manage_courses_screen.dart';
import '../../courses/ui/presentation/screens/Courses/public_courses_screen.dart';
import '../../courses/ui/presentation/screens/Courses/qr_payment_screen.dart';
import '../../courses/ui/presentation/screens/admin/admin_chapters_page.dart';
import '../../courses/ui/presentation/screens/admin/admin_content_page.dart';
import '../../courses/ui/presentation/screens/admin/admin_dashboard_screen.dart';
import '../../courses/ui/presentation/screens/admin/admin_subjects_page.dart';
import '../../courses/ui/presentation/screens/admin/manage_question.dart';
import '../../courses/ui/presentation/screens/admin/manage_students_screen.dart';
import '../../courses/ui/presentation/screens/auth/approval_pending_screen.dart';
import '../../courses/ui/presentation/screens/auth/login_screen.dart';
import '../../courses/ui/presentation/screens/auth/register_screen.dart';

import '../../courses/ui/presentation/screens/dashboard/courses_dashboard_screen.dart';
import '../../courses/ui/presentation/screens/profile/profile_screen.dart';
import '../../courses/ui/presentation/screens/splash/splash_screen.dart';
import '../../courses/ui/presentation/screens/student/chapter_pdf.dart';
import '../../courses/ui/presentation/screens/student/chapters_list_screen.dart';
import '../../courses/ui/presentation/screens/student/pdf_list_screen.dart';
import '../../courses/ui/presentation/screens/student/pdf_vewer_screen.dart';
import '../../courses/ui/presentation/screens/student/subject_pdf.dart';
import '../../courses/ui/presentation/screens/student/subjects_list_screen.dart';
import '../../courses/ui/presentation/screens/student/test_chapter.dart';
import '../../courses/ui/presentation/screens/student/test_results.dart';
import '../../courses/ui/presentation/screens/student/test_screen.dart';
import '../../courses/ui/presentation/screens/student/test_subjects.dart';
import '../../courses/ui/presentation/screens/student/video_list_screen.dart';
import '../../courses/ui/presentation/widgets/video_player_widget.dart';
import 'course_routes.dart';


class AppRouterCourse {
  final AuthCubit authCubit;
  late final GoRouter router;

  AppRouterCourse({required this.authCubit}) {
    router = GoRouter(
      initialLocation: AppRoutesCourses.splash,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      routes: [
        GoRoute(path: AppRoutesCourses.splash, builder: (context, state) => const SplashScreen()),
        GoRoute(path: AppRoutesCourses.login, builder: (context, state) => const LoginScreen()),
        GoRoute(path: AppRoutesCourses.register, builder: (context, state) {
          final courseId = state.extra as String? ?? '';
          return RegisterScreen(courseId: courseId);
        }),
        GoRoute(
          path: AppRoutesCourses.courseDetail,
          builder: (context, state) {
            final course = state.extra as CoursesModel;
            return CourseDetailPage(course: course);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.qrPayment,
          builder: (context, state) {
            final course = state.extra as CoursesModel;
            return QrPaymentScreen(course: course);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.publicCourses,
          builder: (context, state) => const PublicCoursesScreen(),
        ),
        GoRoute(path: AppRoutesCourses.pendingApproval, builder: (context, state) => const PendingApprovalScreen()),
        GoRoute(path: AppRoutesCourses.adminDashboard, builder: (context, state) => const AdminDashboardScreen()),
        GoRoute(path: AppRoutesCourses.manageStudents, builder: (context, state) => const ManageStudentsScreen()),

        GoRoute(
          path: AppRoutesCourses.manageCourses,
          builder: (context, state) => const ManageCoursesScreen(),
        ),
        GoRoute(
          path: AppRoutesCourses.AdminSubjects,
          builder: (context, state) {
            final courseId = state.extra as String;
            return AdminSubjectsPage(courseId: courseId);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.adminContent,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final courseId = data['courseId'] as String;
            final subject = data['subject'] as SubjectModel;
            final chapter = data['chapter'] as ChapterModel;

            return AdminContentPage(courseId: courseId, subject: subject, chapter: chapter);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.AdminChapters,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final courseId = data['courseId'] as String;
            final subject = data['subject'] as SubjectModel;
            return AdminChaptersPage(courseId: courseId, subject: subject);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.pdfList,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final subject = data['subject'] as SubjectModel;
            final chapter = data['chapter'] as ChapterModel;
            final coursesId= data['courseId'] as String;
            return PdfListScreen(subject: subject, chapter: chapter, courseId: coursesId,);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.chaptersList,
          builder: (context, state) {
            // Correctly cast the extra object as a Map
            final extra = state.extra as Map<String, dynamic>;
            final subject = extra['subject'] as SubjectModel;
            final courseId = extra['courseId'] as String;
            return ChaptersListScreen(subject: subject, courseId: courseId);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.chapterPDF,
          builder: (context, state) {
            final extra=state.extra as Map<String,dynamic>;
            final subject=extra['subject'] as SubjectModel;
            final courseId=extra['courseId'] as String;
            return ChapterPdf(subject: subject,courseId: courseId);
          },
        ),

        GoRoute(
          path: AppRoutesCourses.videosList,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final subject = data['subject'] as SubjectModel;
            final chapter = data['chapter'] as ChapterModel;
            final coursesId= data['courseId'] as String;
            return VideosListScreen(subject: subject, chapter: chapter, courseId: coursesId);
          },
        ),
        GoRoute(path: AppRoutesCourses.managesQuestions,
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
          path: '${AppRoutesCourses.videoPlayer}/:videoId',
          builder: (context, state) {
            final videoId = state.pathParameters['videoId']!;
            return VideoPlayerScreen(videoId: videoId, mode: ScreenMode.student);
          },
        ),
        GoRoute(
          path: '${AppRoutesCourses.adminVideoPlayer}/:videoId',
          builder: (context, state) {
            final videoId = state.pathParameters['videoId']!;
            return VideoPlayerScreen(videoId: videoId, mode: ScreenMode.admin);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.pdfViewer,
          builder: (context, state) {
            final url = state.extra as String;
            return PdfViewerScreen(url: url);
          },
        ),
        GoRoute(
          path: AppRoutesCourses.adminPdfViewer,
          builder: (context, state) {
            final url = state.extra as String;
            return PdfViewerScreen(url: url);
          },
        ),

// lib/core/routes/app_routes.dart
// ... other routes ...

        GoRoute(
          path: '/testChapter',
          name: AppRoutesCourses.testChapter, // Name the parent route
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            final subject = data['subject'] as SubjectModel;
            final courseId = data['courseId'] as String;
            return TestChapter(subject: subject, courseId: courseId);
          },
          routes: [
            GoRoute(
              path: '/testScreen', // ✅ Correct: This is a relative path
              name: AppRoutesCourses.testScreen, // Name the nested route
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
              name: AppRoutesCourses.quizResult, // Name the nested route
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
            return DashboardCoursess(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutesCourses.subjectsList, builder: (context, state) => const SubjectsListScreen()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutesCourses.subjectPDF, builder: (context, state) => const SubjectPdf()),
              ],
            ),
            StatefulShellBranch(routes: [
              GoRoute(path: AppRoutesCourses.testSubject,builder: (context,state)=> const TestSubjects()),
            ]),
            StatefulShellBranch(
              routes: [
                GoRoute(path: AppRoutesCourses.profile, builder: (context, state) => const ProfileScreen()),
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
        final isPublicRoute = [
          AppRoutesCourses.splash,
          AppRoutesCourses.publicCourses,
          AppRoutesCourses.courseDetail,
          AppRoutesCourses.qrPayment,
          AppRoutesCourses.login,
          AppRoutesCourses.register,
        ].contains(currentLocation);

        // --- 1. Handle Initial and Loading States ---
        if (authState is AuthInitial || authState is AuthLoading) {
          if (isPublicRoute) {
            return null;
          }
          return AppRoutesCourses.splash;
        }

        // --- 2. Handle Unauthenticated State ---
        if (authState is Unauthenticated) {
          if (authState.pendingApproval) {
            return currentLocation != AppRoutesCourses.pendingApproval ? AppRoutesCourses.pendingApproval : null;
          }
          return isPublicRoute ? null : AppRoutesCourses.publicCourses;
        }

        // --- 3. Handle Authenticated State ---
        if (authState is Authenticated) {
          final user = authState.userModel;
          developer.log('Authenticated user: role=${user.role}, status=${user.status}');

          if (user.status != 'approved') {
            return currentLocation != AppRoutesCourses.pendingApproval ? AppRoutesCourses.pendingApproval : null;
          }

          if (user.role == 'admin') {
            final isAdminRoute = currentLocation.startsWith(AppRoutesCourses.adminDashboard) ||
                currentLocation.startsWith(AppRoutesCourses.manageStudents) ||
                currentLocation.startsWith(AppRoutesCourses.manageCourses) ||
                currentLocation.startsWith(AppRoutesCourses.AdminSubjects) ||
                currentLocation.startsWith(AppRoutesCourses.AdminChapters) ||
                currentLocation.startsWith(AppRoutesCourses.adminContent) ||
                currentLocation.startsWith(AppRoutesCourses.adminVideoPlayer) ||
                currentLocation.startsWith(AppRoutesCourses.adminPdfViewer);

            if (!isAdminRoute) {
              return AppRoutesCourses.adminDashboard;
            }
          } else { // User is a 'student'
            final isStudentRoute = currentLocation.startsWith(AppRoutesCourses.subjectsList) ||
                currentLocation.startsWith(AppRoutesCourses.subjectPDF) ||
                currentLocation.startsWith(AppRoutesCourses.profile) ||
                currentLocation.startsWith(AppRoutesCourses.chaptersList) ||
                currentLocation.startsWith(AppRoutesCourses.chapterPDF) ||
                currentLocation.startsWith(AppRoutesCourses.pdfList) ||
                currentLocation.startsWith(AppRoutesCourses.videosList) ||
                currentLocation.startsWith(AppRoutesCourses.videoPlayer) ||
                currentLocation.startsWith(AppRoutesCourses.pdfViewer)||
                currentLocation.startsWith(AppRoutesCourses.testScreen)||
                currentLocation.startsWith(AppRoutesCourses.testChapter)||
                currentLocation.startsWith(AppRoutesCourses.testSubject);

            if (!isStudentRoute) {
              return AppRoutesCourses.subjectsList;
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

