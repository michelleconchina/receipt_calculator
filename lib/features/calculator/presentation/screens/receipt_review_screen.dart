import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/core/constants/route_paths.dart';
import '../../../receipt/domain/entities/receipt_item.dart';
import '../bloc/calculator_bloc.dart';

class ReceiptReviewScreen extends StatelessWidget {
  const ReceiptReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Receipt')),
      body: BlocBuilder<CalculatorBloc, CalculatorState>(
        builder: (context, state) {
          if (state is! CalculatorLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final receipt = state.receipt;
          final total = state.selectedTotal;

          return Column(
            children: [
              // Items list
              Expanded(
                child: ListView.builder(
                  itemCount: receipt.items.length,
                  itemBuilder: (context, index) {
                    final item = receipt.items[index];
                    return _ReceiptItemTile(
                      item: item,
                      onToggle: () {
                        context.read<CalculatorBloc>().add(
                          ToggleItemEvent(itemId: item.id),
                        );
                      },
                      onRemove: () {
                        context.read<CalculatorBloc>().add(
                          RemoveItemEvent(itemId: item.id),
                        );
                      },
                    );
                  },
                ),
              ),
              // Total section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:'),
                        Text(
                          '${total.currency} ${total.amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => {context.push(kPreviewRoute)},
                      child: const Text('Confirm Total'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReceiptItemTile extends StatelessWidget {
  final ReceiptItem item;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _ReceiptItemTile({
    required this.item,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: item.isSelected, onChanged: (_) => onToggle()),
      title: Text(item.description),
      subtitle: Text(
        '${item.quantity} x ${item.unitPrice.currency} ${item.unitPrice.amount}',
      ),
      trailing: IconButton(icon: const Icon(Icons.delete), onPressed: onRemove),
    );
  }
}
