import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/barbershop_icon.dart';
import '../../core/ui/constants.dart';
import '../../core/ui/helpers/messages.dart';
import '../../core/ui/widgets/avatar_widget.dart';
import '../../core/ui/widgets/hours_panel.dart';
import '../../models/user_model.dart';
import 'schedule_state.dart';
import 'schedule_vm.dart';
import 'widgets/schedule_calendar.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  var dateFormat = DateFormat('dd/MM/yyyy');
  var showCalendar = false;
  final formKey = GlobalKey<FormState>();
  final clientEC = TextEditingController();
  final dateEC = TextEditingController();

  @override
  void dispose() {
    clientEC.dispose();
    dateEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;

    final scheduleVM = ref.watch(scheduleVmProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelADM(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays,
          workHours: workHours,
        ),
    };

    ref.listen(
      scheduleVmProvider.select((state) => state.status),
      (_, status) {
        switch (status) {
          case SecheduleStateStatus.initial:
            break;
          case SecheduleStateStatus.success:
            Messages.showSuccess('Cliente agendado com sucesso', context);
            Navigator.of(context).pop();
          case SecheduleStateStatus.error:
            Messages.showError('Erro ao registrar agendamento', context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                const AvatarWidget(
                  hideUploadButton: true,
                ),
                const SizedBox(height: 24),
                Text(
                  userModel.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 37),
                TextFormField(
                  controller: clientEC,
                  decoration: const InputDecoration(
                    label: Text('Cliente'),
                  ),
                  validator: Validatorless.required('Insira o nome do cliente'),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: dateEC,
                  decoration: const InputDecoration(
                    label: Text('Selecione uma data'),
                    hintText: 'Selecione uma data',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: Icon(
                      BarbershopIcons.calendar,
                      color: ColorsConstants.brow,
                      size: 18,
                    ),
                  ),
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      showCalendar = true;
                    });
                    context.unfocus();
                  },
                  validator:
                      Validatorless.required('Selecione a data do agendamento'),
                ),
                Offstage(
                  offstage: !showCalendar,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      ScheduleCalendar(
                        workDays: employeeData.workDays,
                        cancelPressed: () {
                          setState(() {
                            showCalendar = false;
                          });
                        },
                        okPressed: (value) {
                          setState(() {
                            dateEC.text = dateFormat.format(value);
                            scheduleVM.dateSelect(value);
                            showCalendar = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                HoursPanel.singleSelection(
                  startTime: 6,
                  endTime: 23,
                  enableTimes: employeeData.workHours,
                  onPressed: scheduleVM.hourSelect,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case null || false:
                        Messages.showError('Dados incompletos', context);
                      case true:
                        final hourSelected = ref.watch(scheduleVmProvider
                            .select((state) => state.scheduleHour != null));

                        if (hourSelected) {
                          scheduleVM.register(
                            userModel: userModel,
                            clientName: clientEC.text,
                          );
                        } else {
                          Messages.showError(
                              'Por favor selecione um horário de atendimento',
                              context);
                        }
                    }
                  },
                  child: const Text('AGENDAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
