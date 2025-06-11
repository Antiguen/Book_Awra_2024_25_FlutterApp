import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookaura/models/book.dart';
import 'package:bookaura/widgets/bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod providers for state management
final booksProvider = StateNotifierProvider<BooksNotifier, List<Book>>((ref) => BooksNotifier());
final loadingProvider = StateProvider<bool>((ref) => true);
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class BooksNotifier extends StateNotifier<List<Book>> {
  BooksNotifier() : super([]) {
    fetchBooks();
  }

  final Dio dio = Dio();

  Future<void> fetchBooks() async {
    try {
      final response = await dio.get('http://127.0.0.1:3006/songs');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : jsonDecode(response.data.toString());
        state = data.map((json) => Book.fromJson(json)).toList();
      } else {
        state = [];
      }
    } catch (e) {
      state = [];
    }
  }
}

class HomePage extends ConsumerWidget {
  final List<Book> newBooks;
  final List<Book> yourChoiceBooks;
  final List<Book> authorsChoiceBooks;
  final void Function(Book) onBookUploaded;

  const HomePage({
    super.key,
    required this.newBooks,
    required this.yourChoiceBooks,
    required this.authorsChoiceBooks,
    required this.onBookUploaded,
  });

  Future<String> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    if (token.isEmpty) return 'user';
    final dio = Dio();
    final response = await dio.get(
      'http://localhost:3006/users/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      final data = response.data is Map
          ? response.data
          : jsonDecode(response.data.toString());
      return data['role'] ?? 'user';
    }
    return 'user';
  }

  void _onNavTap(BuildContext context, WidgetRef ref, int index) async {
    ref.read(selectedIndexProvider.notifier).state = index;
    final userRole = await _getUserRole();

    if (userRole == "superadmin") {
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacementNamed('/home');
          break;
        case 1:
          Navigator.of(context).pushReplacementNamed('/search');
          break;
        case 2:
          Navigator.of(context).pushReplacementNamed('/add_author');
          break;
        case 3:
          Navigator.of(context).pushReplacementNamed('/add_book');
          break;
      }
    } else if (userRole == "artist") {
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacementNamed('/home');
          break;
        case 1:
          Navigator.of(context).pushReplacementNamed('/search');
          break;
        case 2:
          Navigator.of(context).pushReplacementNamed('/add_book');
          break;
      }
    } else {
      // For normal users
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacementNamed('/home');
          break;
        case 1:
          Navigator.of(context).pushReplacementNamed('/search');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "BookAura",
          style: TextStyle(
            color: Color(0xFFB17979),
            fontFamily: 'Cursive',
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: books.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: groupBooksByGenre(books).entries.map((entry) {
                  final genre = entry.key;
                  final books = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: BookSection(
                      title: genre,
                      books: books,
                      onBookClick: (book) {
                        Navigator.of(context).pushNamed('/description', arguments: book);
                      },
                    ),
                  );
                }).toList(),
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onNavTap(context, ref, index),
      ),
    );
  }
}

class BookSection extends StatelessWidget {
  final String title;
  final List<Book> books;
  final void Function(Book) onBookClick;

  const BookSection({
    super.key,
    required this.title,
    required this.books,
    required this.onBookClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onClick: () {
                  Navigator.of(context).pushNamed('/description', arguments: book);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onClick;

  const BookCard({super.key, required this.book, required this.onClick});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (book.imageData != null && book.imageData.isNotEmpty) {
      try {
        imageBytes = base64Decode(book.imageData);
      } catch (_) {
        imageBytes = null;
      }
    }
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF23272F),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                    )
                  : Container(
                      height: 120,
                      color: Colors.black12,
                      child: const Icon(Icons.book, color: Colors.white38, size: 60),
                    ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                book.formattedTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                book.formattedArtist,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

Map<String, List<Book>> groupBooksByGenre(List<Book> books) {
  final Map<String, List<Book>> genreMap = {};
  for (final book in books) {
    String genre = book.genre ?? 'Unknown';
    // If genre contains 'children' (case-insensitive), group under 'Children'
    if (genre.toLowerCase().contains('children')) {
      genre = 'Children';
    }
    genreMap.putIfAbsent(genre, () => []).add(book);
  }
  return genreMap;
}