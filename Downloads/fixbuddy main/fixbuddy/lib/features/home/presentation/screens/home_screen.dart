import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  late Future<Map<String, dynamic>?> _profileFuture;
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  late Future<List<Map<String, dynamic>>> _featuredWorkersFuture;
  late Future<List<Map<String, dynamic>>> _nearbyWorkersFuture;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    _profileFuture = _loadProfile();
    _categoriesFuture = _loadCategories();
    _featuredWorkersFuture = _loadFeaturedWorkers();
    _nearbyWorkersFuture = _loadNearbyWorkers();
  }

  Future<void> _refresh() async {
    setState(_reloadData);
    await Future.wait([
      _profileFuture,
      _categoriesFuture,
      _featuredWorkersFuture,
      _nearbyWorkersFuture,
    ]);
  }

  Future<Map<String, dynamic>?> _loadProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return {
        'full_name': 'Rahim Uddin',
        'email': 'rahim.uddin@example.com',
        'profile_image': null,
        'role': 'user',
      };
    }

    try {
      final data = await _client
          .from('profiles')
          .select('full_name, email, profile_image, role')
          .eq('id', userId)
          .maybeSingle();
      return (data as Map<String, dynamic>?) ?? {
        'full_name': 'Rahim Uddin',
        'email': 'rahim.uddin@example.com',
        'profile_image': null,
        'role': 'user',
      };
    } catch (_) {
      return {
        'full_name': 'Rahim Uddin',
        'email': 'rahim.uddin@example.com',
        'profile_image': null,
        'role': 'user',
      };
    }
  }

  Future<List<Map<String, dynamic>>> _loadCategories() async {
    try {
      final data = await _client
          .from('categories')
          .select('id, name, slug, icon, description')
          .eq('is_active', true)
          .order('name', ascending: true);
      final rows = (data as List).whereType<Map<String, dynamic>>().toList();
      return rows.isNotEmpty ? rows : _mockCategories();
    } catch (_) {
      return _mockCategories();
    }
  }

  Future<List<Map<String, dynamic>>> _loadFeaturedWorkers() async {
    try {
      final data = await _client
          .from('workers')
          .select('id, hourly_rate, avg_rating, total_reviews, is_available, service_area, profiles!workers_id_fkey(full_name, profile_image), categories!workers_category_id_fkey(name, slug)')
          .eq('is_available', true)
          .order('avg_rating', ascending: false)
          .limit(6);
      final rows = (data as List).whereType<Map<String, dynamic>>().toList();
      return rows.isNotEmpty ? rows : _mockFeaturedWorkers();
    } catch (_) {
      return _mockFeaturedWorkers();
    }
  }

  Future<List<Map<String, dynamic>>> _loadNearbyWorkers() async {
    try {
      final data = await _client
          .from('workers')
          .select('id, hourly_rate, avg_rating, total_reviews, is_available, service_area, profiles!workers_id_fkey(full_name, profile_image), categories!workers_category_id_fkey(name, slug)')
          .eq('is_available', true)
          .order('created_at', ascending: false)
          .limit(4);
      final rows = (data as List).whereType<Map<String, dynamic>>().toList();
      return rows.isNotEmpty ? rows : _mockNearbyWorkers();
    } catch (_) {
      return _mockNearbyWorkers();
    }
  }

  List<Map<String, dynamic>> _mockCategories() {
    return const [
      {'id': 'cat-1', 'name': 'Plumber', 'slug': 'plumber', 'icon': 'plumbing', 'description': 'Pipe and water line repairs'},
      {'id': 'cat-2', 'name': 'Electrician', 'slug': 'electrician', 'icon': 'electrical_services', 'description': 'Wiring and power fixes'},
      {'id': 'cat-3', 'name': 'Carpenter', 'slug': 'carpenter', 'icon': 'carpenter', 'description': 'Furniture and wood work'},
      {'id': 'cat-4', 'name': 'Tutor', 'slug': 'tutor', 'icon': 'school', 'description': 'Home tutoring support'},
      {'id': 'cat-5', 'name': 'Painter', 'slug': 'painter', 'icon': 'format_paint', 'description': 'Interior and exterior painting'},
      {'id': 'cat-6', 'name': 'Mechanic', 'slug': 'mechanic', 'icon': 'build', 'description': 'Bike and light vehicle service'},
      {'id': 'cat-7', 'name': 'AC Repair', 'slug': 'ac-repair', 'icon': 'ac_unit', 'description': 'Cooling service and maintenance'},
      {'id': 'cat-8', 'name': 'House Cleaning', 'slug': 'house-cleaning', 'icon': 'cleaning_services', 'description': 'Deep cleaning and tidy-up'},
    ];
  }

  List<Map<String, dynamic>> _mockFeaturedWorkers() {
    return [
      _mockWorker('w-101', 'Mizanur Rahman', 'Plumber', 'Dhanmondi', 720, 4.9, 118, true),
      _mockWorker('w-102', 'Farzana Akter', 'Electrician', 'Uttara', 640, 4.8, 92, true),
      _mockWorker('w-103', 'Sabbir Hossain', 'Carpenter', 'Mirpur', 780, 4.7, 76, true),
      _mockWorker('w-104', 'Nabila Sultana', 'Painter', 'Banani', 520, 4.9, 143, true),
      _mockWorker('w-105', 'Tanvir Ahmed', 'Mechanic', 'Mohammadpur', 690, 4.6, 88, true),
      _mockWorker('w-106', 'Jannatul Ferdaus', 'Tutor', 'Gulshan', 1100, 5.0, 54, true),
    ];
  }

  List<Map<String, dynamic>> _mockNearbyWorkers() {
    return [
      _mockWorker('w-201', 'Mizanur Rahman', 'Plumber', 'Dhanmondi', 720, 4.9, 118, true),
      _mockWorker('w-202', 'Farzana Akter', 'Electrician', 'Dhanmondi', 640, 4.8, 92, true),
      _mockWorker('w-203', 'Sabbir Hossain', 'Carpenter', 'Dhanmondi', 780, 4.7, 76, false),
      _mockWorker('w-204', 'Nabila Sultana', 'Painter', 'Dhanmondi', 520, 4.9, 143, true),
    ];
  }

  Map<String, dynamic> _mockWorker(
    String id,
    String name,
    String category,
    String area,
    num hourlyRate,
    double rating,
    int reviews,
    bool available,
  ) {
    return {
      'id': id,
      'hourly_rate': hourlyRate,
      'avg_rating': rating,
      'total_reviews': reviews,
      'is_available': available,
      'service_area': area,
      'profiles': {'full_name': name, 'profile_image': null},
      'categories': {'name': category, 'slug': category.toLowerCase().replaceAll(' ', '-')},
    };
  }

  String _categoryIcon(String? slug) {
    switch ((slug ?? '').toLowerCase()) {
      case 'plumber':
        return '💧';
      case 'electrician':
        return '⚡';
      case 'tutor':
        return '📚';
      case 'painter':
        return '🎨';
      case 'mechanic':
        return '🚗';
      case 'ac-repair':
        return '❄️';
      case 'house-cleaning':
        return '🧹';
      default:
        return '🔧';
    }
  }

  String _shortName(Map<String, dynamic>? profile) {
    final fullName = (profile?['full_name'] ?? 'User').toString().trim();
    if (fullName.isEmpty) return 'User';
    final parts = fullName.split(' ');
    return parts.first;
  }

  String _initials(String? name) {
    final value = (name ?? '').trim();
    if (value.isEmpty) {
      return 'U';
    }

    final parts = value.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return value.characters.first.toUpperCase();
    }

    return parts.take(2).map((part) => part.characters.first).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppTheme.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: _profileFuture,
                builder: (context, profileSnap) {
                  final profile = profileSnap.data;
                  final greetingName = _shortName(profile);

                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.heroTop, AppTheme.heroBottom],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x330F172A),
                          blurRadius: 30,
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 18,
                          top: 18,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                                  child: Text(
                                    _initials(profile?['full_name']?.toString() ?? greetingName),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'শুভ সকাল',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.78),
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Assalamu Alaikum, $greetingName',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            InkWell(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.workers),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 14,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Search services, categories, or workers',
                                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    return _categoriesSection(
                      context,
                      snapshot.data ?? const [],
                      snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _featuredWorkersFuture,
                  builder: (context, snapshot) {
                    return _featuredWorkersSection(
                      context,
                      snapshot.data ?? const [],
                      snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _nearbyWorkersFuture,
                  builder: (context, snapshot) {
                    return _nearbyWorkersSection(
                      context,
                      snapshot.data ?? const [],
                      snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoriesSection(BuildContext context, List<Map<String, dynamic>> categories, bool loading) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Row(
            children: [
              const Expanded(
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.workers),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(child: Text('No categories found')),
            )
          else
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  final slug = (item['slug'] ?? '').toString();
                  final name = (item['name'] ?? 'Category').toString();
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '${AppRoutes.workers}?category=${Uri.encodeComponent(name)}',
                    ),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 108,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryLight,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(_categoryIcon(slug), style: const TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item['slug'] ?? 'service'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _featuredWorkersSection(BuildContext context, List<Map<String, dynamic>> workers, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Row(
          children: [
            const Expanded(
              child: Text(
                'Featured Workers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.workers),
              child: const Text('See all'),
            ),
          ],
        ),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (workers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(child: Text('No featured workers found')),
          )
        else
          SizedBox(
            height: 248,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: workers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final worker = workers[index];
                final profile = worker['profiles'] as Map<String, dynamic>?;
                final category = worker['categories'] as Map<String, dynamic>?;
                final name = (profile?['full_name'] ?? 'Worker').toString();
                final categoryName = (category?['name'] ?? 'Service').toString();
                final rating = (worker['avg_rating'] as num?)?.toDouble() ?? 0;
                final reviews = (worker['total_reviews'] as int?) ?? 0;
                final area = (worker['service_area'] ?? 'Local service area').toString();
                final workerId = (worker['id'] ?? '').toString();

                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '${AppRoutes.workerProfile}?workerId=${Uri.encodeComponent(workerId)}',
                  ),
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    width: 228,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primaryLight,
                              child: Text(
                                _initials(name),
                                style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '৳${(worker['hourly_rate'] as num?)?.toStringAsFixed(0) ?? '0'}/hr',
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppTheme.iconAmber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '($reviews)',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          area,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '${AppRoutes.booking}?workerId=${Uri.encodeComponent(workerId)}',
                            ),
                            child: const Text('Book now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _nearbyWorkersSection(BuildContext context, List<Map<String, dynamic>> workers, bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby Workers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 14),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (workers.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(child: Text('No nearby workers found')),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final worker = workers[index];
              final profile = worker['profiles'] as Map<String, dynamic>?;
              final category = worker['categories'] as Map<String, dynamic>?;
              final name = (profile?['full_name'] ?? 'Worker').toString();
              final categoryName = (category?['name'] ?? 'Service').toString();
              final rating = (worker['avg_rating'] as num?)?.toDouble() ?? 0;
              final workerId = (worker['id'] ?? '').toString();

              return InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  '${AppRoutes.workerProfile}?workerId=${Uri.encodeComponent(workerId)}',
                ),
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppTheme.primaryLight,
                        child: Text(
                          _initials(name),
                          style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '৳${(worker['hourly_rate'] as num?)?.toStringAsFixed(0) ?? '0'}/hr',
                                    style: const TextStyle(
                                      color: AppTheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              categoryName,
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppTheme.iconAmber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    (worker['service_area'] ?? 'Local service area').toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
