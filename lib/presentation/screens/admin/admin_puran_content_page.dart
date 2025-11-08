import 'package:flutter/material.dart';
import 'package:ibs_platform/presentation/screens/admin/admin_puran_videos_list.dart';
import 'package:ibs_platform/presentation/screens/admin/admin_puran_pdfs_list.dart';
import 'package:ibs_platform/presentation/screens/admin/admin_puran_texts_list.dart';

class AdminPuranContentPage extends StatelessWidget {
  // Keep the API simple so other admin screens can open it easily
  final String puranTitle;
  final String subjectTitle;
  final String puranId;
  final String subjectId;
  final String chapterId; // which chapter to manage

  const AdminPuranContentPage({
    super.key,
    required this.puranTitle,
    required this.subjectTitle,
    required this.puranId,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // show puran and subject for context
          title: Text('$puranTitle - $subjectTitle'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.videocam), text: 'Videos'),
              Tab(icon: Icon(Icons.picture_as_pdf), text: 'PDFs'),
              Tab(icon: Icon(Icons.article), text: 'Text'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AdminPuranVideosList(puranId: puranId, subjectId: subjectId, chapterId: chapterId),
            AdminPuranPdfsList(puranId: puranId, subjectId: subjectId, chapterId: chapterId),
            AdminPuranTextsList(puranId: puranId, subjectId: subjectId, chapterId: chapterId),
          ],
        ),
      ),
    );
  }
}
