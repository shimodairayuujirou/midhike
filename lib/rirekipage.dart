import 'package:flutter/material.dart';

class RirekiPage extends StatelessWidget {
  const RirekiPage({super.key});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF3D1A6F);

    return Scaffold(
      backgroundColor: purple,
      appBar: AppBar(
        backgroundColor: purple,
        elevation: 0,
        title: const Text(
          '履歴',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text('歩いた歩数順☆'),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text('日付順☆'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildHistoryCard(
                  context,
                  title: '中目黒駅前〜目黒川中目黒公園',
                  steps: '6,793歩',
                  time: '1day ago AM 0:02',
                  imagePath: 'assets/images/nakameguro.jpeg',
                ),
                _buildHistoryCard(
                  context,
                  title: '不動前駅〜BOOKOFF PLUS西五反田店',
                  steps: '7,251歩',
                  time: '3days ago PM 23:54',
                  imagePath: 'assets/images/bookoff.jpeg',
                ),
                _buildHistoryCard(
                  context,
                  title: '秋葉原駅A3口〜ベルサール秋葉原',
                  steps: '5,864歩',
                  time: '6days ago AM 0:02',
                  imagePath: 'assets/images/akihabara.jpg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required String title,
    required String steps,
    required String time,
    required String imagePath,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('記録歩数: $steps\n$time'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'view') {
                  // 記録を表示するページへ遷移
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('記録を見るをタップ')),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Text('記録を見る'),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: 300, // 適度な幅を指定
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
