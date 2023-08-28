import 'package:flutter/material.dart';

enum SecheduleStateStatus {
  initial,
  success,
  error,
}

class ScheduleState {
  final SecheduleStateStatus status;
  final int? scheduleHour;
  final DateTime? scheduleDate;

  ScheduleState.initial() : this(status: SecheduleStateStatus.initial);

  ScheduleState({
    required this.status,
    this.scheduleHour,
    this.scheduleDate,
  });

  ScheduleState copyWith({
    SecheduleStateStatus? status,
    ValueGetter<int?>? scheduleHour,
    ValueGetter<DateTime?>? scheduleDate,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      scheduleHour: scheduleHour != null ? scheduleHour() : this.scheduleHour,
      scheduleDate: scheduleDate != null ? scheduleDate() : this.scheduleDate,
    );
  }
}
