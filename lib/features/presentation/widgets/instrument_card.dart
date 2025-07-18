import 'package:flutter/material.dart';
import 'package:raise_right_task/features/domain/entities/instruments.dart';

class InstrumentCard extends StatelessWidget {
  final Instrument instrument;

  const InstrumentCard(this.instrument, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(instrument.baseCurrency, style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('${instrument.lastPx ?? '-'} ${instrument.quoteCurrency}'),
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Vol. spike/24h", style: textTheme.titleMedium),
                      Text((instrument.vol24h ?? "..").toString() , style: textTheme.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
