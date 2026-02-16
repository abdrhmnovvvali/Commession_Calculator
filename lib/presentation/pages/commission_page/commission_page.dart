import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/commission/commission_cubit.dart';
import 'widgets/commission_error_view.dart';
import 'widgets/commission_initial_view.dart';
import 'widgets/commission_results_view.dart';

class CommissionPage extends StatelessWidget {
  const CommissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commission Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CommissionCubit>().reset(),
          ),
        ],
      ),
      body: BlocBuilder<CommissionCubit, CommissionState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return switch (state) {
            CommissionInitial() => const CommissionInitialView(),
            CommissionLoading() => const Center(child: CircularProgressIndicator()),
            CommissionSuccess(:final results) => CommissionResultsView(results: results),
            CommissionFailure(:final message) => CommissionErrorView(message: message),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
