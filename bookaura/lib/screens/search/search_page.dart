import 'package:bookaura/models/book.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod StateNotifier for search logic
class SearchNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  SearchNotifier() : super(const AsyncData([]));

  final Dio dio = Dio();

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    try {
      // Search by title
      final titleResponse = await dio.get(
        'http://localhost:3006/songs/search/title',
        queryParameters: {'title': query},
      );
      List<Book> titleResults = [];
      if (titleResponse.statusCode == 200) {
        final List<dynamic> data = titleResponse.data;
        titleResults = data.map((json) => Book.fromJson(json)).toList();
      }

      // Search by artist
      final artistResponse = await dio.get(
        'http://localhost:3006/songs/artist/$query',
      );
      List<Book> artistResults = [];
      if (artistResponse.statusCode == 200) {
        final List<dynamic> data = artistResponse.data;
        artistResults = data.map((json) => Book.fromJson(json)).toList();
      }

      // Combine and remove duplicates by id
      final allResults = <String, Book>{};
      for (var b in [...titleResults, ...artistResults]) {
        allResults[b.id] = b;
      }

      state = AsyncData(allResults.values.toList());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<Book>>>(
  (ref) => SearchNotifier(),
);

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchPage extends ConsumerWidget {
  final List<Book> allBooks;
  const SearchPage({super.key, required this.allBooks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchAsync = ref.watch(searchProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
          ),
          title: const Text(
            "BookAura",
            style: TextStyle(
              color: Color(0xFFB17979),
              fontFamily: 'Cursive',
              fontSize: 24,
            ),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search books...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFB17979)),
                  filled: true,
                  fillColor: const Color(0xFF333333),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFB17979)),
                  ),
                ),
                onChanged: (query) {
                  ref.read(searchQueryProvider.notifier).state = query;
                  ref.read(searchProvider.notifier).search(query);
                },
              ),
              const SizedBox(height: 16),
              // Search Results
              Expanded(
                child: searchAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB17979)),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      "Error: $err",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  data: (searchResults) => searchQuery.isEmpty
                      ? const Center(
                          child: Text(
                            "Search for books by title or author",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : searchResults.isEmpty
                          ? const Center(
                              child: Text(
                                "No books found",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.separated(
                              itemCount: searchResults.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final book = searchResults[index];
                                return _BookSearchItem(
                                  book: book,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/description',
                                      arguments: book,
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookSearchItem extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  const _BookSearchItem({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF333333),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "By ${book.artist}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}