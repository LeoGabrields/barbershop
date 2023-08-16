import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/service_excepiton.dart';
import '../../../core/fp/either.dart';
import '../../../core/providers/application_providers.dart';
import 'login_state.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    final loaderHandle = AsyncLoaderHandler()..start();

    final loginService = ref.watch(userLoginServiceProvider);

    final result = await loginService.execute(email, password);

    switch (result) {
      case Success():
        // Buscar dados do usuário logado
        // Fazer uma analise para qual o tipo do Login
        break;
      case Failure(exception: ServiceExcepiton(:final message)):
        state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    loaderHandle.close();
  }
}
