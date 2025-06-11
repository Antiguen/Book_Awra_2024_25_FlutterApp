import 'package:intl/intl.dart';

class Book {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final String description;
  final String songContentType;
  final String imageContentType;
  final String uploadDate;
  final String imageData;

  Book({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.description,
    required this.songContentType,
    required this.imageContentType,
    required this.uploadDate,
    required this.imageData,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      album: json['album'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      description: json['description'] as String? ?? '',
      songContentType: json['songContentType'] as String? ?? '',
      imageContentType: json['imageContentType'] as String? ?? '',
      uploadDate: json['uploadDate']?.toString() ?? '',
      imageData: json['imageData'] as String? ?? '',
    );
  }

  String get imageUrl => "http://192.168.1.3:3006/songs/$id";

  String get formattedDate {
    try {
      final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final outputFormat = DateFormat("MMM dd, yyyy");
      final date = inputFormat.parse(uploadDate, true).toLocal();
      return outputFormat.format(date);
    } catch (_) {
      return uploadDate;
    }
  }

  String get defaultImageUrl => "https://via.placeholder.com/150?text=No+Image";

  String get formattedGenre => genre.isNotEmpty
      ? "${genre[0].toUpperCase()}${genre.substring(1)}"
      : genre;

  String get formattedArtist => artist.isNotEmpty
      ? "${artist[0].toUpperCase()}${artist.substring(1)}"
      : artist;

  String get formattedTitle => title.isNotEmpty
      ? "${title[0].toUpperCase()}${title.substring(1)}"
      : title;

  String get formattedDescription => description.isNotEmpty
      ? "${description[0].toUpperCase()}${description.substring(1)}"
      : description;

  String get formattedAlbum => album.isNotEmpty
      ? "${album[0].toUpperCase()}${album.substring(1)}"
      : album;
}