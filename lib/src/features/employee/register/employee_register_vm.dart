import 'package:asyncstate/asyncstate.dart';
import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:barbershop/src/repositories/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/fp/nil.dart';
import '../../../models/barbershop_model.dart';

part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {
  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterADM(bool isRegisterADM) {
    state = state.copyWith(registerADM: isRegisterADM);
  }

  void addOrRemoveWorkdays(String weekDay) {
    final workDays = state.workdays;

    if (workDays.contains(weekDay)) {
      workDays.remove(weekDay);
    } else {
      workDays.add(weekDay);
    }

    state.copyWith(workdays: workDays);
  }

  void addOrRemoveWorkhours(int hour) {
    final workhours = state.workhours;

    if (workhours.contains(hour)) {
      workhours.remove(hour);
    } else {
      workhours.add(hour);
    }

    state.copyWith(workhours: workhours);
  }

  Future<void> register({String? name, String? email, String? password}) async {
    final EmployeeRegisterState(:registerADM, :workdays, :workhours) = state;
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final UserRepository(:registerAdmAsEmployee, :registerEmployee) =
        ref.read(userRepositoryProvider);

    final Either<RepositoryException, Nil> resultRegister;

    if (registerADM) {
      final dto = (
        workdays: workdays,
        workhours: workhours,
      );
      resultRegister = await registerAdmAsEmployee(dto);
    } else {
      final BarbershopModel(:id) =
          await ref.watch(getMyBarbershopProvider.future);
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workdays: workdays,
        workhours: workhours,
      );

      resultRegister = await registerEmployee(dto);
    }

    switch (resultRegister) {
      case Success():
        state = state.copyWith(status: EmployeeRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: EmployeeRegisterStateStatus.error);
    }
    asyncLoaderHandler.close();
  }
}
