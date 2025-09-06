import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/groups/presentation/pages/groups_page.dart';
import '../../features/groups/presentation/pages/create_group_page.dart';
import '../../features/groups/presentation/pages/join_group_page.dart';
import '../../features/photos/presentation/pages/photo_viewer_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../services/auth_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  
  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final isOnboardingCompleted = authService.isOnboardingCompleted;
      
      // Check authentication
      if (!isAuthenticated) {
        if (state.location != '/auth') {
          return '/auth';
        }
      } else {
        // Check onboarding
        if (!isOnboardingCompleted && state.location != '/onboarding') {
          return '/onboarding';
        }
        
        // Redirect to home if already authenticated and onboarded
        if (state.location == '/auth' || state.location == '/onboarding') {
          return '/home';
        }
      }
      
      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (context, state) {
          final groupId = state.uri.queryParameters['groupId'];
          return CameraPage(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/groups',
        name: 'groups',
        builder: (context, state) => const GroupsPage(),
        routes: [
          GoRoute(
            path: '/create',
            name: 'create-group',
            builder: (context, state) => const CreateGroupPage(),
          ),
          GoRoute(
            path: '/join',
            name: 'join-group',
            builder: (context, state) {
              final code = state.uri.queryParameters['code'];
              return JoinGroupPage(inviteCode: code);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/photo/:photoId',
        name: 'photo-viewer',
        builder: (context, state) {
          final photoId = state.pathParameters['photoId']!;
          final groupId = state.uri.queryParameters['groupId'];
          return PhotoViewerPage(
            photoId: photoId,
            groupId: groupId,
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
        routes: [
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});

// Deep Link Handler
class AppRouter {
  static void handleDeepLink(String link) {
    final uri = Uri.parse(link);
    
    if (uri.host == 'cameragold.app') {
      if (uri.path.startsWith('/photo/')) {
        final photoId = uri.pathSegments[1];
        final groupId = uri.queryParameters['groupId'];
        // Navigate to photo viewer
        // GoRouter.of(context).go('/photo/$photoId?groupId=$groupId');
      } else if (uri.path.startsWith('/group/')) {
        final groupId = uri.pathSegments[1];
        // Navigate to group
        // GoRouter.of(context).go('/groups');
      } else if (uri.path.startsWith('/invite/')) {
        final inviteCode = uri.pathSegments[1];
        // Navigate to join group
        // GoRouter.of(context).go('/groups/join?code=$inviteCode');
      }
    }
  }
}
