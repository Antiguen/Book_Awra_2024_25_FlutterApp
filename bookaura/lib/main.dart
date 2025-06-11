import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/signup_page.dart';
import 'screens/profile/edit_profile_page.dart';
import 'screens/story/add_story_page.dart';
import 'screens/library/library_page.dart' as lib;
import 'screens/custom/my_view_page.dart';
import 'screens/profile/profile_page.dart';
import 'screens/search/search_page.dart' as search;
import 'screens/reading/reading_page.dart';
import 'screens/admin/add_author_page.dart';
import 'screens/story/add_book_page.dart';
import 'screens/story/description_page.dart' as desc;
import 'models/book.dart';
import 'screens/home/home_page.dart';
import 'screens/auth/forgot_password_page.dart';
import 'screens/landing/landing_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookAura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/add_story': (context) => const AddStoryPage(),
        '/library': (context) => const lib.LibraryPage(),
        '/my_view': (context) => const MyViewPage(),
        '/profile': (context) => const ProfilePage(),
        '/search': (context) => search.SearchPage(allBooks: []),
        '/reading': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return ReadingPage(bookId: args['bookId']);
        },
        '/add_author': (context) => const AddAuthorPage(),
        '/add_book': (context) => const AddBookPage(),
        '/description': (context) {
          final book = ModalRoute.of(context)!.settings.arguments as Book?;
          if (book == null) {
            return const Scaffold(
              body: Center(child: Text('No book data provided')),
            );
          }
          return desc.DescriptionPage(book: book);
        },
        '/home':
            (context) => HomePage(
              newBooks: [],
              yourChoiceBooks: [],
              authorsChoiceBooks: [],
              onBookUploaded: (book) {},
            ),
        '/forgot_password': (context) => const ForgotPasswordPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/description') {
          final Book book = settings.arguments as Book;
          return MaterialPageRoute(
            builder: (context) => desc.DescriptionPage(book: book),
          );
        }
        if (settings.name == '/reading') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => ReadingPage(bookId: args['bookId']),
          );
        }
        return null;
      },
    );
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}
