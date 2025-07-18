import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raise_right_task/core/utils/di/di.dart' show sl;
import 'package:raise_right_task/features/presentation/bloc/instruments_bloc.dart';
import 'package:raise_right_task/features/presentation/bloc/states/states.dart';
import 'package:raise_right_task/features/presentation/widgets/instrument_card.dart';

import '../bloc/events/events.dart' show LoadInstruments;

class InstrumentsScreen extends StatelessWidget {
  const InstrumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Dashboard')),
      body: BlocProvider(
        create: (_) => sl<InstrumentsBloc>()..add(LoadInstruments()),
        child: BlocBuilder<InstrumentsBloc, InstrumentsState>(
          builder: (context, state) {
            if(state is InstrumentsError){
              return Expanded(
                child: Center(
                  child: Text(state.message, textAlign: TextAlign.center,)
                ),
              );
            }
            if(state is InstrumentsLoaded){
              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;

                  if (constraints.maxWidth < 600) {
                    crossAxisCount = 1; // Mobile
                  } else if (constraints.maxWidth < 1024) {
                    crossAxisCount = 2; // Tablet
                  } else {
                    crossAxisCount = 4; // Desktop
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: state.instruments.length,
                    itemBuilder: (context, index) {
                      final instrument = state.instruments[index];
                      return InstrumentCard(instrument);
                    },
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
