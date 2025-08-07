import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midhike/footer.dart';

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
        MaterialPageRoute(builder: (_) => Root()),
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
      backgroundColor: const Color(0xFF3D1A6F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D1A6F),
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', width: 90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'プロフィール作成',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: '名前',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            TextField(
              controller: _nicknameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'ニックネーム',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3D1A6F),
                  padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 24),
                ),
              child: const Text('登録してホームへ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 12),
            Text(
              _message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
