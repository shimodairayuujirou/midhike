import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midhike/home_page.dart';
import 'package:midhike/TrackingPage.dart';
import 'package:midhike/profile.dart';
import 'package:midhike/rirekipage.dart';
import 'package:midhike/search.dart';
import 'package:midhike/setting_page.dart';

// プロバイダー
final indexProvider = StateProvider((ref) => 0);

// 画面全体（フッター付き）
class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のインデックス
    final index = ref.watch(indexProvider);

    // ナビゲーションバーの項目
    const items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: Colors.grey),
        label: 'ホーム',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/person.png')),
        label: 'プロフィール',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/search.png')),
        label: '検索',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/sozai.png')),
        label: '履歴',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/post.png')),
        label: '投稿',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/images/setting.png')),
        label: '投稿',
      ),
    ];

    // ページリスト（index に応じて表示）
    final pages = [
      HomePage(),
      ProfilePage(),
      SearchPage(),
      RirekiPage(),
      TrackingPage(),
      SettingPage(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: items,
        backgroundColor: const Color(0xFF3D1A6F),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 158, 148, 148),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        iconSize: 50,
        currentIndex: index,
        onTap: (index) {
          ref.read(indexProvider.notifier).state = index;
        },
      ),
    );
  }
}
