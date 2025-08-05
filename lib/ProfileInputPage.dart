import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart'; // ← ホーム画面への遷移に使います

class ProfileInputPage extends StatefulWidget {
  const ProfileInputPage({super.key});

  @override
  State<ProfileInputPage> createState() => _ProfileInputPageState();
}

class _ProfileInputPageState extends State<ProfileInputPage> {
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();

  String _message = '';

  Future<void> _submitProfile() async {
    final name = _nameController.text.trim();
    final nickname = _nicknameController.text.trim();

    if (name.isEmpty || nickname.isEmpty) {
      setState(() {
        _message = 'すべての項目を入力してください';
      });
      return;
    }

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'nickname': nickname,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 入力完了後、ホーム画面に遷移（戻れないようにする）
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _message = '登録エラー: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール登録')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '名前'),
            ),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: 'ニックネーム'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: const Text('登録してホームへ'),
            ),
            const SizedBox(height: 12),
            Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
