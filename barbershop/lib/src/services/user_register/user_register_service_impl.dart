import '../../core/exceptions/service_excepiton.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../repositories/user/user_repository.dart';
import '../user_login/user_login_service.dart';
import 'user_register_service.dart';

class UserRegisterServiceImpl implements UserRegisterService {
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  UserRegisterServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(
      ({String email, String name, String password}) userData) async {
    final registerResult = await userRepository.registerAdmin(userData);

    switch (registerResult) {
      case Success():
        return userLoginService.execute(userData.email, userData.password);
      case Failure(:final exception):
        return Failure(ServiceException(message: exception.message));
    }
  }
}
