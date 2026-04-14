import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_map_app/thems/styles.dart';
import 'package:sound_map_app/view/top/my_page.dart';
import 'package:sound_map_app/view/top/top_page.dart';

class TopPageRoute extends ConsumerWidget {
  TopPageRoute({super.key});

  final _pageWidgets = [TopPage(), ConfigPage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(currentIndexProvider);
    final Size size = MediaQuery.of(context).size;
    final double iconSize = size.shortestSide / 10;
    return Scaffold(
      body: _pageWidgets.elementAt(currentIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 3,
              color: Styles.primaryColor,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: _buildNavigationIconWithName(
                  Icon(Icons.map_outlined,
                      size: iconSize, color: Styles.secondaryColor),
                  'map',
                ),
                activeIcon: _buildNavigationIconWithName(
                    Icon(Icons.map_outlined,
                        size: iconSize, color: Styles.primaryColor),
                    'map',
                    isFocus: true),
                label: 'map'),
            BottomNavigationBarItem(
                icon: _buildNavigationIconWithName(
                    Icon(Icons.account_circle,
                        size: iconSize, color: Styles.secondaryColor),
                    'account'),
                activeIcon: _buildNavigationIconWithName(
                    Icon(Icons.account_circle,
                        size: iconSize, color: Styles.primaryColor),
                    'account',
                    isFocus: true),
                label: 'account'),
          ],
          currentIndex: currentIndex,
          fixedColor: Styles.accentColor,
          onTap: (int index) {
            ref.read(currentIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.shifting,
        ),
      ),
    );
  }

  Widget _buildNavigationIconWithName(Widget icon, String label,
      {bool isFocus = false}) {
    return Column(
      children: [
        icon,
        Text(label,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isFocus ? Styles.secondaryColor : Styles.primaryColor)),
      ],
    );
  }
}

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});
