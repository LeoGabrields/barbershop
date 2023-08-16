import '../../core/exceptions/service_excepiton.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';

abstract interface class UserLoginService {
  Future<Either<ServiceExcepiton, Nil>> execute(String email, String password);
}
