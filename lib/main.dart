import 'package:flutter/material.dart';

void main() => runApp(const StudentProfileApp());

class StudentProfileApp extends StatefulWidget {
  const StudentProfileApp({super.key});
  @override
  State<StudentProfileApp> createState() => _StudentProfileAppState();
}

class _StudentProfileAppState extends State<StudentProfileApp> {
  ThemeMode mode = ThemeMode.light;
  static const seed = Color(0xFF6750A4);

  ThemeData makeTheme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: 'StudentSans',
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: brightness == Brightness.dark ? 1 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontSize: 15, height: 1.4),
        bodyMedium: TextStyle(fontSize: 13, height: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Student Profile Dashboard',
        debugShowCheckedModeBanner: false,
        theme: makeTheme(Brightness.light),
        darkTheme: makeTheme(Brightness.dark),
        themeMode: mode,
        routes: {
          '/': (_) => DashboardScreen(
                isDark: mode == ThemeMode.dark,
                onThemeChanged: (dark) => setState(
                    () => mode = dark ? ThemeMode.dark : ThemeMode.light),
              ),
          '/details': (_) => const StudentDetailsScreen(),
        },
        initialRoute: '/',
      );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  static const avatar =
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard', style: t.textTheme.titleLarge),
        actions: [
          IconButton(
            tooltip: 'Switch theme',
            onPressed: () => onThemeChanged(!isDark),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          _ProfileHeader(avatar: avatar),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _StatCard(icon: Icons.menu_book, label: 'Courses', value: '06', color: c.primary)),
            const SizedBox(width: 8),
            Expanded(child: _StatCard(icon: Icons.grade, label: 'GPA', value: '3.82', color: c.tertiary)),
            const SizedBox(width: 8),
            Expanded(child: _StatCard(icon: Icons.task_alt, label: 'Tasks', value: '12', color: c.secondary)),
          ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Academic overview', style: t.textTheme.titleLarge),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/details'),
                child: const Text('View details'),
              ),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(
                    backgroundColor: c.primaryContainer,
                    child: Icon(Icons.auto_graph, color: c.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Semester progress', style: t.textTheme.titleMedium),
                    Text('Spring semester • 2026', style: t.textTheme.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
                  ])),
                  Text('72%', style: t.textTheme.titleLarge?.copyWith(color: c.primary)),
                ]),
                const SizedBox(height: 16),
                const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: LinearProgressIndicator(value: .72, minHeight: 9),
                ),
                const SizedBox(height: 10),
                Text('You are on track. Keep up your weekly study routine.', style: t.textTheme.bodyMedium),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Text('Upcoming schedule', style: t.textTheme.titleLarge),
          Card(
            child: Column(children: const [
              _ScheduleTile(icon: Icons.code, title: 'Mobile App Development', subtitle: 'Today • 10:30 AM – Room B204', time: '10:30'),
              Divider(height: 1, indent: 68),
              _ScheduleTile(icon: Icons.storage, title: 'Database Systems', subtitle: 'Tomorrow • 09:00 AM – Room A105', time: '09:00'),
            ]),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: c.secondaryContainer,
                child: Icon(Icons.person_outline, color: c.onSecondaryContainer),
              ),
              title: Text('Student details', style: t.textTheme.titleMedium),
              subtitle: Text('View contact and academic information', style: t.textTheme.bodyMedium),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, '/details'),
            ),
          ),
          Center(
            child: Text('Demo data • Replace with your own details',
                style: t.textTheme.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.avatar});
  final String avatar;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.primary, Color.lerp(c.primary, c.tertiary, .72)!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: .85), width: 2),
            ),
            child: CircleAvatar(
              radius: 47,
              backgroundColor: c.surfaceContainerHighest,
              backgroundImage: NetworkImage(avatar),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          Positioned(
            right: -2,
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF16885B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Text('Arian Rahmani', style: t.textTheme.headlineMedium?.copyWith(color: Colors.white, fontSize: 25)),
        const SizedBox(height: 5),
        Text('Computer Science Student', style: t.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: .9))),
        const SizedBox(height: 13),
        Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: const [
          _HeaderChip(icon: Icons.badge_outlined, text: 'ID: CS-2026-041'),
          _HeaderChip(icon: Icons.location_on_outlined, text: 'Kabul, Afghanistan'),
        ]),
      ]),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .16),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: .25)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 6),
        child: Column(children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 8),
          Text(value, style: t.textTheme.titleLarge),
          const SizedBox(height: 3),
          Text(label, style: t.textTheme.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.icon, required this.title, required this.subtitle, required this.time});
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      leading: CircleAvatar(
        backgroundColor: c.primaryContainer,
        child: Icon(icon, color: c.onPrimaryContainer),
      ),
      title: Text(title, style: t.textTheme.titleMedium),
      subtitle: Text(subtitle, style: t.textTheme.bodyMedium),
      trailing: Text(time, style: t.textTheme.bodyMedium?.copyWith(color: c.primary, fontWeight: FontWeight.bold)),
    );
  }
}

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Student Details', style: t.textTheme.titleLarge)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [c.primary, c.tertiary], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(children: [
              const CircleAvatar(radius: 38, backgroundImage: NetworkImage(DashboardScreen.avatar)),
              const SizedBox(height: 12),
              Text('Arian Rahmani', style: t.textTheme.titleLarge?.copyWith(color: Colors.white)),
              Text('Computer Science • Year 3', style: t.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: .9))),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Text('Personal information', style: t.textTheme.titleLarge),
        Card(child: const Column(children: [
          _InfoTile(icon: Icons.email_outlined, label: 'Email', value: 'arian.student@example.com'),
          Divider(height: 1, indent: 68),
          _InfoTile(icon: Icons.phone_outlined, label: 'Phone', value: '+93 700 000 000'),
          Divider(height: 1, indent: 68),
          _InfoTile(icon: Icons.location_on_outlined, label: 'Location', value: 'Kabul, Afghanistan'),
        ])),
        const SizedBox(height: 12),
        Text('Academic information', style: t.textTheme.titleLarge),
        Card(child: const Column(children: [
          _InfoTile(icon: Icons.school_outlined, label: 'Program', value: 'BSc Computer Science'),
          Divider(height: 1, indent: 68),
          _InfoTile(icon: Icons.numbers, label: 'Student ID', value: 'CS-2026-041'),
          Divider(height: 1, indent: 68),
          _InfoTile(icon: Icons.grade_outlined, label: 'Current GPA', value: '3.82 / 4.00'),
        ])),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to dashboard'),
        ),
      ]),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: c.secondaryContainer,
        child: Icon(icon, color: c.onSecondaryContainer),
      ),
      title: Text(label, style: t.textTheme.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
      subtitle: Text(value, style: t.textTheme.titleMedium),
    );
  }
}
