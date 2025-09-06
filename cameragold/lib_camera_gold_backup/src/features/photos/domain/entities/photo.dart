import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

@freezed
class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String groupId,
    required String authorId,
    required String authorName,
    required String authorAvatar,
    required String photoUrl,
    required String thumbnailUrl,
    required DateTime timestamp,
    String? caption,
    @Default({}) Map<String, int> reactions,
    @Default([]) List<Comment> comments,
    @Default(false) bool isDeleted,
  }) = _Photo;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String authorId,
    required String authorName,
    required String content,
    required DateTime timestamp,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
