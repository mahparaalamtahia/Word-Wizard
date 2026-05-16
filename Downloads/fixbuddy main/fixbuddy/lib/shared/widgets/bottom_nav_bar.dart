import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isWorker;
  final int unreadCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isWorker = false,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = isWorker
        ? const [
            _Tab('Home', Icons.home_outlined, Icons.home),
            _Tab('Bookings', Icons.calendar_today_outlined, Icons.calendar_today),
            _Tab('Alerts', Icons.notifications_outlined, Icons.notifications),
            _Tab('Dashboard', Icons.dashboard_outlined, Icons.dashboard),
            _Tab('Profile', Icons.person_outline, Icons.person),
          ]
        : const [
            _Tab('Home', Icons.home_outlined, Icons.home),
            _Tab('Bookings', Icons.calendar_today_outlined, Icons.calendar_today),
            _Tab('Alerts', Icons.notifications_outlined, Icons.notifications),
            _Tab('Profile', Icons.person_outline, Icons.person),
          ];

    final safe = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 12 + safe),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.navBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: _TabItem(
                    tab: tabs[i],
                    active: i == currentIndex,
                    showBadge: tabs[i].label == 'Alerts' && unreadCount > 0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final _Tab tab;
  final bool active;
  final bool showBadge;

  const _TabItem({required this.tab, required this.active, required this.showBadge});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.navActive : AppTheme.navInactive;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? AppTheme.primaryLight : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(active ? tab.filled : tab.outlined, size: 22, color: color),
              if (showBadge)
                const Positioned(
                  right: -5,
                  top: -4,
                  child: CircleAvatar(radius: 4, backgroundColor: AppTheme.iconRed),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          tab.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Tab {
  final String label;
  final IconData outlined;
  final IconData filled;

  const _Tab(this.label, this.outlined, this.filled);
}
