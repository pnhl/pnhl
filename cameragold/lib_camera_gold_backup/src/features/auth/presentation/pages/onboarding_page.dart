import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentPage + 1) / 4,
              backgroundColor: Colors.grey.shade200,
            ),
            
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildUsernamePage(),
                  _buildPermissionsPage(),
                  _buildCompletePage(),
                ],
              ),
            ),
            
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    OutlinedButton(
                      onPressed: _previousPage,
                      child: const Text('Quay lại'),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _nextPage,
                    child: Text(_currentPage == 3 ? 'Hoàn thành' : 'Tiếp tục'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.waving_hand,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Chào mừng đến với Camera Gold!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Chia sẻ những khoảnh khắc đẹp với bạn bè và gia đình. Xem ảnh của họ ngay trên màn hình chính.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUsernamePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Chọn tên người dùng',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Tên này sẽ hiển thị cho bạn bè khi bạn gửi ảnh.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Tên người dùng',
                prefixIcon: Icon(Icons.alternate_email),
                helperText: 'Chỉ chữ cái, số và dấu gạch dưới',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập tên người dùng';
                }
                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value!)) {
                  return 'Tên người dùng không hợp lệ';
                }
                if (value.length < 3) {
                  return 'Tên người dùng phải có ít nhất 3 ký tự';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.security,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Cấp quyền truy cập',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Để sử dụng đầy đủ tính năng, chúng tôi cần một số quyền:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildPermissionItem(
            Icons.camera_alt,
            'Camera',
            'Để chụp và chia sẻ ảnh',
          ),
          const SizedBox(height: 16),
          _buildPermissionItem(
            Icons.photo_library,
            'Thư viện ảnh',
            'Để chọn ảnh từ thư viện',
          ),
          const SizedBox(height: 16),
          _buildPermissionItem(
            Icons.notifications,
            'Thông báo',
            'Để nhận thông báo về ảnh mới',
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String description) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildCompletePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Mọi thứ đã sẵn sàng!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn có thể bắt đầu tạo nhóm và chia sẻ ảnh với bạn bè ngay bây giờ.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _nextPage() async {
    if (_currentPage == 1) {
      // Validate username
      if (!_formKey.currentState!.validate()) return;
    }
    
    if (_currentPage == 2) {
      // Request permissions
      await _requestPermissions();
    }
    
    if (_currentPage == 3) {
      // Complete onboarding
      context.go('/home');
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _requestPermissions() async {
    try {
      // Request camera permission
      await Permission.camera.request();
      
      // Request photo library permission
      await Permission.photos.request();
      
      // Request notification permission
      await Permission.notification.request();
      
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }
}
