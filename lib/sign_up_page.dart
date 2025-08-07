import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:midhike/ProfileInputPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:midhike/footer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  Future<void> _signUp() async {
  try {
    // Firebase Authentication にユーザー作成
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Firestore にユーザー情報があるか確認
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!doc.exists) {
      // ユーザー情報が未登録 → プロフィール登録ページへ（履歴を消して遷移）
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProfileInputPage()),
        (route) => false,
      );
    } else {
      // 既に登録済み → ホーム画面へ（履歴を消して遷移）
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Root()),
        (route) => false,
      );
    }
  } catch (e) {
    setState(() {
      _message = '登録エラー: $e';
    });
    print(e);
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
              '新規登録',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'メールアドレス',
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
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'パスワード',
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
              onPressed: _signUp,
              child: const Text('登録'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3D1A6F),
                padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 24),
              ),
            ),
            const SizedBox(height: 20),
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
