import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_map_app/thems/styles.dart';
import 'package:sound_map_app/provider/login/login_provider.dart';
import 'package:sound_map_app/provider/login/login_state.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginState loginState = ref.watch(loginProvider);
    final String infoText = loginState.infoText;
    final String email = loginState.email;
    final String name = loginState.name;
    final String password = loginState.password;
    final bool isLoginMode = loginState.isLoginMode;

    return Scaffold(
      appBar: AppBar(
          shape:
              Border(bottom: BorderSide(color: Styles.primaryColor, width: 3)),
          backgroundColor: Colors.white,
          title: isLoginMode
              ? const Text('Sigin in',
                  style: TextStyle(color: Styles.primaryColor))
              : const Text('Create an account.',
                  style: TextStyle(color: Styles.primaryColor))),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'email address'),
                onChanged: (String value) {
                  ref.read(loginProvider.notifier).changeEmail(value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (String value) {
                  ref.read(loginProvider.notifier).changePassword(value);
                },
              ),
              isLoginMode
                  ? const SizedBox()
                  : TextFormField(
                      decoration: const InputDecoration(labelText: 'Your name'),
                      onChanged: (String value) {
                        ref.read(loginProvider.notifier).changeName(value);
                      },
                    ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              isLoginMode
                  ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        child: const Text('Sign in'),
                        onPressed: () async {
                          try {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            await auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            if (FirebaseAuth.instance.currentUser == null) {
                              return;
                            }
                            ref.read(loginProvider.notifier).changeUser(
                                FirebaseAuth.instance.currentUser!.email!);
                            ref
                                .read(loginProvider.notifier)
                                .changeInfoText('');
                          } on FirebaseAuthException catch (e) {
                            ref.read(loginProvider.notifier).changeInfoText(
                                _friendlySignInErrorMessage(e.code));
                          } catch (e) {
                            ref.read(loginProvider.notifier).changeInfoText(
                                'ログインに失敗しました。時間をおいて再度お試しください。');
                          }
                        },
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text('Create an account.'),
                        onPressed: () async {
                          try {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            final result =
                                await auth.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            ref
                                .read(loginProvider.notifier)
                                .changeUser(result.user!.email!);

                            if (result.user == null) {
                              return;
                            }
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(result.user?.email)
                                .set({
                              'name': name.isEmpty ? 'unnamed' : name,
                              'date': DateTime.now().toLocal().toIso8601String()
                            });
                            ref.read(loginProvider.notifier).changeMode(true);
                            ref.read(loginProvider.notifier).changeName('');
                            ref
                                .read(loginProvider.notifier)
                                .changeInfoText('');
                          } on FirebaseAuthException catch (e) {
                            ref.read(loginProvider.notifier).changeInfoText(
                                _friendlySignUpErrorMessage(e.code));
                          } catch (e) {
                            ref.read(loginProvider.notifier).changeInfoText(
                                '新規作成に失敗しました。時間をおいて再度お試しください。');
                          }
                        },
                      ),
                    ),
              const SizedBox(
                height: 8,
              ),
              isLoginMode
                  ? SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          child: const Text('Create an account.'),
                          onPressed: () async {
                            ref.read(loginProvider.notifier).changeMode(false);
                          }))
                  : SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          child: const Text('Sign in'),
                          onPressed: () async {
                            ref.read(loginProvider.notifier).changeMode(true);
                          })),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _friendlySignInErrorMessage(String code) {
  switch (code) {
    case 'user-not-found':
      return 'アカウントが見つかりません。新規登録してください。';
    case 'wrong-password':
      return 'メールアドレスまたはパスワードが違います。';
    case 'invalid-credential':
      return 'メールアドレスまたはパスワードが違います。';
    case 'invalid-email':
      return 'メールアドレスの形式が正しくありません。';
    case 'user-disabled':
      return 'このアカウントは無効化されています。';
    case 'too-many-requests':
      return 'しばらく操作が集中しているようです。少し時間をおいてお試しください。';
    case 'operation-not-allowed':
      return 'このログイン方法は有効になっていません。';
    default:
      return 'ログインに失敗しました。時間をおいて再度お試しください。';
  }
}

String _friendlySignUpErrorMessage(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'このメールアドレスは既に登録されています。ログインしてください。';
    case 'invalid-email':
      return 'メールアドレスの形式が正しくありません。';
    case 'weak-password':
      return 'パスワードの安全性が十分でないようです。文字数や組み合わせを見直してください。';
    case 'operation-not-allowed':
      return '新規登録が無効になっています。';
    default:
      return '新規作成に失敗しました。時間をおいて再度お試しください。';
  }
}
