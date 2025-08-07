import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  List<String> _fakeResults = [
    "人気急上昇ルート",
    "おすすめルート",
    "最新の投稿",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '検索',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3D1A6F),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'キーワードを入力',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // 今は検索処理なし（仮実装）
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _fakeResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.place, color: Color(0xFF3D1A6F)),
                  title: Text(_fakeResults[index]),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // 何もしない（仮）
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

