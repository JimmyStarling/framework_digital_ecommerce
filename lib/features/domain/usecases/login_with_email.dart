import 'package:dartz/dartz.dart';
import 'package:framework_digital_ecommerce/core/exceptions/internal.dart';
import 'package:framework_digital_ecommerce/features/domain/entities/user_info_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:framework_digital_ecommerce/core/exceptions/failures.dart';
import 'package:framework_digital_ecommerce/core/exceptions/login.dart';
import 'package:framework_digital_ecommerce/features/domain/entities/conectivity_entity.dart';
import 'package:framework_digital_ecommerce/features/domain/entities/login_credentials.dart';

import '../repositories/login_repository.dart';

part 'login_with_email.g.dart';

abstract class LoginWithEmail {
  Future<Either<Failure, LoggedUserInfo>> call(LoginCredentials credential);
}

@Injectable()
class LoginWithEmailImpl implements LoginWithEmail {
  final LoginRepository repository;
  final ConnectivityService service;

  LoginWithEmailImpl(this.repository, this.service);

  @override
  Future<Either<Failure, LoggedUserInfo>> call(LoginCredentials credential) async {
    var result = await service.isOnline();

    if (result.isLeft()) {
      result.map((r) => null);
      return Left(InternalException(message: "Internal Error."));
    }

    if (!credential.isValidEmail) {
      return const Left(LoginEmailException(message: "Invalid Email"));
    } else if (!credential.isValidPassword) {
      return const Left(LoginEmailException(message: "Invalid Password"));
    }

    return await repository.loginEmail(
      email: credential.email,
      password: credential.password,
    );
  }
}