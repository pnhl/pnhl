import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _FeedTab(),
          _GroupsTab(),
          _CameraTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            // Camera tab - navigate to camera page
            context.push('/camera');
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Nhóm',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Chụp ảnh',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}

class _FeedTab extends ConsumerWidget {
  const _FeedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Gold'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh feed
        },
        child: CustomScrollView(
          slivers: [
            // Pinned Groups Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhóm đã ghim',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _buildPinnedGroupCard(context, index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Recent Photos Feed
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Ảnh gần đây',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildPhotoCard(context, index);
                },
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/camera');
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildPinnedGroupCard(BuildContext context, int index) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade300,
                  Colors.purple.shade300,
                ],
              ),
            ),
            child: const Icon(
              Icons.group,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhóm ${index + 1}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://picsum.photos/seed/${index + 100}/100/100',
              ),
            ),
            title: Text('Người dùng ${index + 1}'),
            subtitle: const Text('Vừa xong'),
            trailing: const Icon(Icons.more_vert),
          ),
          
          // Photo
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://picsum.photos/seed/${index + 200}/400/400',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Actions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // TODO: Add reaction
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // TODO: Show comments
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    // TODO: Share photo
                  },
                ),
                const Spacer(),
                const Text('5 reactions'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsTab extends ConsumerWidget {
  const _GroupsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhóm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/groups/create');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://picsum.photos/seed/${index + 300}/100/100',
              ),
            ),
            title: Text('Nhóm ${index + 1}'),
            subtitle: Text('${index + 2} thành viên'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to group details
            },
          );
        },
      ),
    );
  }
}

class _CameraTab extends ConsumerWidget {
  const _CameraTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This tab is handled by navigation to camera page
    return const SizedBox.shrink();
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/profile/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://picsum.photos/seed/user/200/200',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tên người dùng',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '@username',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(context, '12', 'Ảnh'),
                _buildStatItem(context, '5', 'Nhóm'),
                _buildStatItem(context, '24', 'Bạn bè'),
              ],
            ),
            const SizedBox(height: 32),
            
            // Menu Items
            _buildMenuItem(
              context,
              Icons.photo_library,
              'Ảnh của tôi',
              () {},
            ),
            _buildMenuItem(
              context,
              Icons.group,
              'Nhóm của tôi',
              () => context.push('/groups'),
            ),
            _buildMenuItem(
              context,
              Icons.person_add,
              'Mời bạn bè',
              () {},
            ),
            _buildMenuItem(
              context,
              Icons.help_outline,
              'Trợ giúp',
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
