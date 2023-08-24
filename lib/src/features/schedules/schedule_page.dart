import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/barbershop_icon.dart';
import '../../core/ui/constants.dart';
import '../../core/ui/widgets/avatar_widget.dart';
import 'widgets/schedule_calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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
                const Text(
                  'Nome e Sobrenome',
                  style: TextStyle(
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
                        cancelPressed: () {
                          setState(() {
                            showCalendar = false;
                          });
                        },
                        okPressed: (value) {
                          setState(() {
                            dateEC.text = dateFormat.format(value);
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
                  enableTimes: const [6, 7, 8],
                  onPressed: (hours) {},
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
                      // Chamada do VM
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
