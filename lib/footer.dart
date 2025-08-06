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
  return 0;
});

// 画面全体
class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // インデックス
    final index = ref.watch(indexProvider);

    // アイテムズ
    const items = [
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

    // 下のバー
    final bar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items, // アイテムズ
      backgroundColor: Color(0xFF3D1A6F), // バー色
      selectedItemColor: Colors.white, // 選ばれたアイテムの色
      unselectedItemColor: const Color.fromARGB(255, 158, 148, 148), // 選ばれていないアイテムの色
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      iconSize: 50, // アイコンのサイズ
      currentIndex: index, // インデックス
      onTap: (index) {
        // タップされたとき インデックスを変更する
        ref.read(indexProvider.notifier).state = index;
      },
    );

    const pages = [
      PageA(),
      PageB(),
      PageC(),
      PageD(),
      PageE(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: bar,
    );
  }
}
