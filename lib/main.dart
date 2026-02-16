import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/locator.dart';
import 'cubits/commission/commission_cubit.dart';
import 'presentation/pages/commission_page/commission_page.dart';

void main() {
  setupLocator();
  runApp(const CommissionApp());
}

class CommissionApp extends StatelessWidget {
  const CommissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commission Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => locator<CommissionCubit>(),
        child: const CommissionPage(),
      ),
    );
  }
}
