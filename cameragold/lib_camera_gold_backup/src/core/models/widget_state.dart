import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_state.freezed.dart';
part 'widget_state.g.dart';

@freezed
class WidgetState with _$WidgetState {
  const factory WidgetState({
    required String groupId,
    required String groupName,
    required String photoUrl,
    required String thumbnailUrl,
    required String senderName,
    required String senderAvatar,
    required DateTime timestamp,
    String? caption,
    @Default(0) int reactionCount,
    @Default(false) bool hasNewContent,
  }) = _WidgetState;

  factory WidgetState.fromJson(Map<String, dynamic> json) =>
      _$WidgetStateFromJson(json);
      
  factory WidgetState.empty() => WidgetState(
        groupId: '',
        groupName: 'No Groups',
        photoUrl: '',
        thumbnailUrl: '',
        senderName: '',
        senderAvatar: '',
        timestamp: DateTime.now(),
      );
}
