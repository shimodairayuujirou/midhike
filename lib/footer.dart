import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


main() {
  // アプリ
  const app = MaterialApp(home: Root());

  // プロバイダースコープ
  const scope = ProviderScope(child: app);
  runApp(scope);
}

// プロバイダー
final indexProvider = StateProvider((ref) {
  // 変化するデータ 0, 1, 2...
  return 1;
});

// 画面全体
class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // インデックス
    final index = ref.watch(indexProvider);

    // アイテムズ
    const items01 = [
      BottomNavigationBarItem(
        icon: Icon(Icons.dehaze_rounded),
        label: 'ハンバーガー',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/person.png')),
        label: 'アイテムA',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/search.png')),
        label: 'アイテムB',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/sozai.png')),
        label: 'アイテムC',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/post.png')),
        label: 'アイテムD',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/sita.png')),
        label: 'アイテムE',
      ),
    ];

    const items02 = [
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/cancel.png')),
        label: 'キャンセル',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/camera.png')),
        label: 'カメラ',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/share.png')),
        label: 'シェア',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.wallet_giftcard_rounded),
        label: 'クーポン',
      ),
      BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('images/setting.png')),
        label: '設定',
      ),
    ];


    // 下のバー
    final bar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: index == 0 ? items02 : items01, // アイテムたち
      backgroundColor: Color(0xFF3D1A6F), // バーの色
      selectedItemColor: Colors.white, // 選ばれたアイテムの色
      unselectedItemColor: const Color.fromARGB(255, 158, 148, 148), // 選ばれていないアイテムの色
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      iconSize: 50, // アイコンのサイズ
      currentIndex: index,
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
      );

    const pages = [
      Damy(),
      PageA(),
      PageB(),
      PageC(),
      PageD(),
      PageE(),
    ];

    return Scaffold(
        body: index == 0? Container() :pages[index],
        bottomNavigationBar: bar
    );
  }
}
