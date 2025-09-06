import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupPage extends ConsumerWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo nhóm mới'),
      ),
      body: const Center(
        child: Text('Create Group Page - To be implemented'),
      ),
    );
  }
}
