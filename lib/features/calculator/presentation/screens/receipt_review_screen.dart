import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_calculator/core/constants/route_paths.dart';
import '../../../receipt/domain/entities/money.dart';
import '../../../receipt/domain/entities/receipt_item.dart';
import '../bloc/calculator_bloc.dart';

class ReceiptReviewScreen extends StatelessWidget {
  const ReceiptReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Receipt'),
        actions: [
          BlocBuilder<CalculatorBloc, CalculatorState>(
            builder: (context, state) {
              final hasItems =
                  state is CalculatorLoaded && state.receipt.items.isNotEmpty;
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear all items',
                onPressed: hasItems ? () => _confirmClearAll(context) : null,
              );
            },
          ),
        ],
      ),
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
                child: receipt.items.isEmpty
                    ? const Center(child: Text('No items'))
                    : ListView.builder(
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
                    if (!receipt.serviceCharge.isZero ||
                        !receipt.vatAmount.isZero) ...[
                      _AmountRow(
                        label: 'Items',
                        amount: receipt.selectedItemsSubtotal,
                      ),
                      if (!receipt.serviceCharge.isZero)
                        _AmountRow(
                          label: 'Service charge',
                          amount: receipt.selectedServiceCharge,
                        ),
                      if (!receipt.vatAmount.isZero)
                        _AmountRow(
                          label: 'VAT (included)',
                          amount: receipt.vatAmount,
                        ),
                      const SizedBox(height: 8),
                    ],
                    _AmountRow(
                      label: 'Total:',
                      amount: total,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: receipt.items.isEmpty
                          ? null
                          : () => context.push(kHomeRoute),
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

  Future<void> _confirmClearAll(BuildContext context) async {
    final bloc = context.read<CalculatorBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear all items?'),
        content: const Text(
          'This removes every scanned item from the receipt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      bloc.add(const ClearAllItemsEvent());
    }
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.label, required this.amount, this.style});

  final String label;
  final Money amount;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '${amount.currency} ${amount.amount.toStringAsFixed(2)}',
          style: style,
        ),
      ],
    );
  }
}

class _ReceiptItemTile extends StatelessWidget {
  const _ReceiptItemTile({
    required this.item,
    required this.onToggle,
    required this.onRemove,
  });

  final ReceiptItem item;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

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
