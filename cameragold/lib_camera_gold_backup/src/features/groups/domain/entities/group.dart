import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required String description,
    required String creatorId,
    required List<String> memberIds,
    required List<GroupMember> members,
    required DateTime createdAt,
    required String inviteCode,
    String? avatarUrl,
    @Default(false) bool isPrivate,
    @Default(20) int maxMembers,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

@freezed
class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String userId,
    required String name,
    required String email,
    required GroupRole role,
    required DateTime joinedAt,
    String? avatarUrl,
    @Default(true) bool isActive,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) => _$GroupMemberFromJson(json);
}

enum GroupRole {
  admin,
  member,
}

@freezed
class GroupInvite with _$GroupInvite {
  const factory GroupInvite({
    required String id,
    required String groupId,
    required String inviteCode,
    required String createdBy,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default(0) int usedCount,
    @Default(false) bool isActive,
  }) = _GroupInvite;

  factory GroupInvite.fromJson(Map<String, dynamic> json) => _$GroupInviteFromJson(json);
}
