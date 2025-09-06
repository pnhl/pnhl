import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinGroupPage extends ConsumerWidget {
  final String? inviteCode;
  
  const JoinGroupPage({super.key, this.inviteCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tham gia nhóm'),
      ),
      body: Center(
        child: Text('Join Group Page - Code: $inviteCode'),
      ),
    );
  }
}
