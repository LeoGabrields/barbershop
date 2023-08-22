import 'package:barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barbershop/src/core/ui/helpers/form_helper.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/barbershop_icon.dart';
import '../../../core/ui/constants.dart';
import '../../../core/ui/widgets/barbershop_loader.dart';

class HomeHeader extends ConsumerWidget {
  final bool hideFilter;

  const HomeHeader({super.key, this.hideFilter = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barbershop = ref.watch(getMyBarbershopProvider);

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: DecorationImage(
          image: AssetImage(
            ImageConstants.backgroundChair,
          ),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          barbershop.maybeWhen(
            data: (barbershopData) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xffbdbdbd),
                    child: SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      barbershopData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Editar',
                      style: TextStyle(
                        color: ColorsConstants.brow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(homeAdmVmProvider.notifier).logout();
                    },
                    icon: const Icon(
                      BarbershopIcons.exit,
                      color: ColorsConstants.brow,
                      size: 24,
                    ),
                  )
                ],
              );
            },
            orElse: () {
              return const Center(
                child: BarbershopLoader(),
              );
            },
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Bem vindo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: const Text(
              'Agende um Cliente',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
          ),
          Offstage(
            offstage: hideFilter,
            child: const SizedBox(
              height: 24,
            ),
          ),
          Offstage(
            offstage: hideFilter,
            child: TextFormField(
              onTapOutside: (_) => context.unfocus(),
              decoration: const InputDecoration(
                label: Text('Buscar Colaborador'),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    BarbershopIcons.search,
                    color: ColorsConstants.brow,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
