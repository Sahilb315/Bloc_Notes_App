// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final String postedAt;
  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.postedAt,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    String? postedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      postedAt: postedAt ?? this.postedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'postedAt': postedAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      postedAt: map['postedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) => NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, description: $description, postedAt: $postedAt)';
  }

  @override
  bool operator ==(covariant NoteModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.postedAt == postedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      postedAt.hashCode;
  }
}
