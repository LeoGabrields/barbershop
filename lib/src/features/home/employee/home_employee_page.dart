import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/home/employee/home_employee_provider.dart';
import 'package:barbershop/src/features/home/widgets/home_header.dart';
import 'package:barbershop/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);

    return Scaffold(
        body: userModelAsync.when(
      loading: () => const BarbershopLoader(),
      error: (error, stackTrace) {
        return const Center(
          child: Text('Erro ao carregar página'),
        );
      },
      data: (user) {
        final UserModel(:name, id: userId) = user;
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: HomeHeader(hideFilter: true),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const AvatarWidget(hideUploadButton: true),
                    const SizedBox(height: 14),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      height: 108,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsConstants.grey),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final totalAsync = ref.watch(
                                  getTotalSchedulesTodayProvider(userId));

                              return totalAsync.when(
                                skipLoadingOnRefresh: false,
                                loading: () => const BarbershopLoader(),
                                error: (error, stackTrace) {
                                  return const Text(
                                      'Erro ao carregar total de agendamentos');
                                },
                                data: (totalSchedules) {
                                  return Text(
                                    '$totalSchedules',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      color: ColorsConstants.brow,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const Text(
                            'Hoje',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      onPressed: () async {
                        await Navigator.of(context)
                            .pushNamed('/schedule', arguments: user);
                        ref.invalidate(getTotalSchedulesTodayProvider);
                      },
                      child: const Text('AGENDAR CLIENTE'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/employee/schedule', arguments: user);
                      },
                      child: const Text('VER AGENDA'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
