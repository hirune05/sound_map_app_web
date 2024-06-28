import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sound_map_app/models/account/account.dart';
part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    @Default(Account()) Account account,
  }) = _AccountState;
}
