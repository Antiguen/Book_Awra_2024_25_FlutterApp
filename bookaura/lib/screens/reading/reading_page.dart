import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod StateNotifier for PDF reading state
class ReadingState extends StateNotifier<AsyncValue<_ReadingData>> {
  final String bookId;
  final Dio dio = Dio();

  ReadingState(this.bookId) : super(const AsyncLoading()) {
    _initPdfController();
  }

  Future<void> _initPdfController() async {
    state = const AsyncLoading();
    try {
      final response = await dio.get<List<int>>(
        'http://localhost:3006/songs/$bookId/pdf',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to load PDF');
      }
      final pdfDocFuture = PdfDocument.openData(Uint8List.fromList(response.data!));
      final controller = PdfControllerPinch(document: pdfDocFuture, initialPage: 1);
      final pdfDoc = await pdfDocFuture;
      final totalPages = pdfDoc.pagesCount;
      state = AsyncData(_ReadingData(
        controller: controller,
        currentPage: 1,
        totalPages: totalPages,
      ));
    } catch (e, st) {
      state = AsyncError("Error loading PDF: $e", st);
    }
  }

  void goToPage(int page) {
    final data = state.value;
    if (data != null && data.controller != null) {
      data.controller!.jumpToPage(page);
      state = AsyncData(data.copyWith(currentPage: page));
    }
  }

  void onPageChanged(int page) {
    final data = state.value;
    if (data != null) {
      state = AsyncData(data.copyWith(currentPage: page));
    }
  }

  @override
  void dispose() {
    state.value?.controller?.dispose();
    super.dispose();
  }
}

class _ReadingData {
  final PdfControllerPinch? controller;
  final int currentPage;
  final int totalPages;

  _ReadingData({
    required this.controller,
    required this.currentPage,
    required this.totalPages,
  });

  _ReadingData copyWith({
    PdfControllerPinch? controller,
    int? currentPage,
    int? totalPages,
  }) {
    return _ReadingData(
      controller: controller ?? this.controller,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

final readingProvider = StateNotifierProvider.autoDispose
    .family<ReadingState, AsyncValue<_ReadingData>, String>(
  (ref, bookId) => ReadingState(bookId),
);

class ReadingPage extends ConsumerWidget {
  final String bookId;
  const ReadingPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingAsync = ref.watch(readingProvider(bookId));
    final readingNotifier = ref.read(readingProvider(bookId).notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6F1),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFB17979).withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFB17979)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          "BookAura",
          style: TextStyle(
            color: Color(0xFFB17979),
            fontFamily: 'Cursive',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: readingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFB17979))),
        error: (err, _) => Center(
          child: Text(
            err.toString(),
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
        data: (data) => data.controller == null
            ? const Center(child: Text("PDF not loaded"))
            : Stack(
                children: [
                  // PDF Viewer
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: PdfViewPinch(
                          controller: data.controller!,
                          onPageChanged: (page) {
                            readingNotifier.onPageChanged(page);
                          },
                        ),
                      ),
                    ),
                  ),
                  // Floating page indicator and controls
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.10),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left, size: 32, color: Color(0xFFB17979)),
                                onPressed: data.currentPage > 1
                                    ? () => readingNotifier.goToPage(data.currentPage - 1)
                                    : null,
                              ),
                              Text(
                                "Page ${data.currentPage} of ${data.totalPages}",
                                style: const TextStyle(
                                  color: Color(0xFFB17979),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right, size: 32, color: Color(0xFFB17979)),
                                onPressed: data.currentPage < data.totalPages
                                    ? () => readingNotifier.goToPage(data.currentPage + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
