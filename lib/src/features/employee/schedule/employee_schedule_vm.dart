import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/fp/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/schedule_model.dart';

part 'employee_schedule_vm.g.dart';

@riverpod
class EmployeeScheduleVM extends _$EmployeeScheduleVM {
  @override
  Future<List<ScheduleModel>> build(int userId, DateTime date) async {
    final repository = ref.read(scheduleRepositoryProvider);

    final scheduleListResult =
        await repository.findScheduleByDate((userId: userId, date: date));

    return switch (scheduleListResult) {
      Success(value: final schedules) => schedules,
      Failure(:final exception) => throw Exception(exception)
    };
  }
}
