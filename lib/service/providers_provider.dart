import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_map_app/models/account/account.dart';
import 'package:sound_map_app/models/account/account_state.dart';
import 'package:sound_map_app/provider/login/login_provider.dart';

final accountProvider =
    StateNotifierProvider<AccountStateProvider, AccountState>(
  (ref) => AccountStateProvider(ref),
);

class AccountStateProvider extends StateNotifier<AccountState> {
  AccountStateProvider(this._ref) : super(const AccountState()) {
    init();
  }

  final fireAccountService = FireAccountService();
  final Ref _ref;

  Future<void> init() async {
    final String email = _ref.read(loginProvider).user.email;
    final fetchedAccount = await fireAccountService.fetchAccount(email);
    state = state.copyWith(account: fetchedAccount);
  }

  void updateAccount(Account account) {
    state = state.copyWith(account: account);
  }
}

class FireAccountService {
  final _fireStore = FirebaseFirestore.instance;

  Future<Account> fetchAccount(String email) async {
    final document =
        await _fireStore.collection('users').doc(email).get();

    return const Account().copyWith(name: document['name']);
  }
}
