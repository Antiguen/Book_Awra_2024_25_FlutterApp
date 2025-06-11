class User {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? bio;
  final String? genre;
  final String? description;
  final String? imageUrl;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.bio,
    this.genre,
    this.description,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id'] ?? '',
        email: json['email'] ?? '',
        fullName: json['fullName'] ?? '',
        role: json['role'] ?? '',
        bio: json['bio'],
        genre: json['genre'],
        description: json['description'],
        imageUrl: json['imageUrl'],
      );
}