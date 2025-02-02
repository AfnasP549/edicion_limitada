import 'package:edicion_limitada/features/address_management/bloc/address_bloc.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/address_management/view/address_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool showSelection;
  final bool isSelected;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    Key? key,
    required this.address,
    this.showSelection = false,
    this.isSelected = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.phoneNumber,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showSelection && isSelected)
                  const Icon(Icons.check_circle, color: Colors.blue),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            Text(
              address.street,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              '\${address.city}, \${address.state}',
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              'PIN: \${address.pincode}',
              style: const TextStyle(fontSize: 15),
            ),
            if (!showSelection) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _handleEdit(context),
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _handleDelete(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<AddressBloc>(context),
        child: AddressDialog(
          address: address,
          onSave: (updatedAddress) {
            context.read<AddressBloc>().add(
              UpdateAddressEvent(address.id!, updatedAddress),
            );
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text(
          'Are you sure you want to delete this address?\n\n'
          '\${address.name}\n'
          '\${address.street}\n'
          '\${address.city}, \${address.state}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (address.id != null) {
                context.read<AddressBloc>().add(DeleteAddressEvent(address.id!));
              }
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
