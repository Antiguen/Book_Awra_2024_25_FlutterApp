import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Book model
class Book {
  final String id;
  final String title;
  final String artist;
  final String imageData;
  Book({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageData,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      imageData: json['imageData'] ?? '',
    );
  }
}

// Riverpod providers
final bookmarkedBooksProvider = StateNotifierProvider<BookmarkedBooksNotifier, AsyncValue<List<Book>>>(
  (ref) => BookmarkedBooksNotifier(),
);

class BookmarkedBooksNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  BookmarkedBooksNotifier() : super(const AsyncLoading()) {
    fetchBookmarkedBooks();
  }

  final Dio dio = Dio();

  Future<void> fetchBookmarkedBooks() async {
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final userResponse = await dio.get(
        'http://localhost:3006/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (userResponse.statusCode == 200) {
        final userData = userResponse.data is Map
            ? userResponse.data
            : jsonDecode(userResponse.data.toString());
        final List<dynamic> library = userData['library'] ?? [];
        if (library.isEmpty) {
          state = const AsyncData([]);
          return;
        }

        List<Book> books = [];
        for (final bookId in library) {
          final bookResponse = await dio.get(
            'http://localhost:3006/songs/$bookId',
          );
          if (bookResponse.statusCode == 200) {
            final bookJson = bookResponse.data is Map
                ? bookResponse.data
                : jsonDecode(bookResponse.data.toString());
            books.add(Book.fromJson(bookJson));
          }
        }
        state = AsyncData(books);
      } else {
        state = AsyncError('Failed to load bookmarked books.', StackTrace.current);
      }
    } catch (e) {
      state = AsyncError('Failed to load bookmarked books.', StackTrace.current);
    }
  }
}

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedBooksAsync = ref.watch(bookmarkedBooksProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB17979)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Bookmarked Books",
            style: TextStyle(
              color: Color(0xFFB17979),
              fontSize: 32,
              fontFamily: 'Cursive',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: bookmarkedBooksAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFB17979)),
              ),
              error: (err, _) => Center(
                child: Text(
                  err.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              data: (books) => books.isEmpty
                  ? const Center(
                      child: Text(
                        "No bookmarked books yet...",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: books.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return _BookRow(
                          book: book,
                          onTap: () async {
                            await Navigator.of(context).pushNamed('/description', arguments: book);
                            // Refresh after returning
                            ref.read(bookmarkedBooksProvider.notifier).fetchBookmarkedBooks();
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookRow extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  const _BookRow({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (book.imageData.isNotEmpty) {
      try {
        imageWidget = Image.memory(
          base64Decode(book.imageData),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 80,
            height: 80,
            color: Colors.grey,
            child: const Icon(Icons.book, color: Colors.white),
          ),
        );
      } catch (_) {
        imageWidget = Container(
          width: 80,
          height: 80,
          color: Colors.grey,
          child: const Icon(Icons.book, color: Colors.white),
        );
      }
    } else {
      imageWidget = Container(
        width: 80,
        height: 80,
        color: Colors.grey,
        child: const Icon(Icons.book, color: Colors.white),
      );
    }

    return Card(
      color: Colors.grey[900],
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageWidget,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Serif',
                      ),
                    ),
                    Text(
                      "by ${book.artist}",
                      style: const TextStyle(
                        color: Color(0xFFB17979),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}