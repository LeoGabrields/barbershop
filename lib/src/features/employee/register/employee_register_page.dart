import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/employee/register/employee_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/widgets/avatar_widget.dart';
import '../../../core/ui/widgets/hours_panel.dart';
import '../../../core/ui/widgets/week_days_panel.dart';
import '../../../models/barbershop_model.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  var registerADM = false;

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVM = ref.watch(employeeRegisterVmProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Colaborador'),
      ),
      body: barbershopAsyncValue.when(
        error: (error, stackTrace) {
          return const Center(
            child: Text('Erro ao carregar a página'),
          );
        },
        loading: () {
          return const BarbershopLoader();
        },
        data: (barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Checkbox.adaptive(
                              value: registerADM,
                              onChanged: (_) {
                                setState(() {
                                  registerADM = !registerADM;
                                  employeeRegisterVM
                                      .setRegisterADM(registerADM);
                                });
                              }),
                          const Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastar como colaborador',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: registerADM,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: nameEC,
                              onTapOutside: (_) => context.unfocus(),
                              decoration: const InputDecoration(
                                label: Text('Name'),
                              ),
                              validator:
                                  Validatorless.required('Nome obrigatório'),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: emailEC,
                              onTapOutside: (_) => context.unfocus(),
                              decoration: const InputDecoration(
                                label: Text('E-mail'),
                              ),
                              validator: Validatorless.multiple([
                                Validatorless.required('E-mail obrigatório'),
                                Validatorless.email('E-mail invalido')
                              ]),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: passwordEC,
                              onTapOutside: (_) => context.unfocus(),
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text('Senha'),
                              ),
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha obrigatória'),
                                Validatorless.min(
                                    6, 'Senha deve contar no min 6 caracteres')
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      WeekDaysPanel(
                        enabledDays: openingDays,
                        onDayPressed: employeeRegisterVM.addOrRemoveWorkdays,
                      ),
                      const SizedBox(height: 24),
                      HoursPanel(
                        startTime: 6,
                        endTime: 23,
                        enableTimes: openingHours,
                        onPressed: employeeRegisterVM.addOrRemoveWorkhours,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () {},
                        child: const Text('CADASTRAR COLABORADOR'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
