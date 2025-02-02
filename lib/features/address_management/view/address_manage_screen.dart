import 'package:edicion_limitada/features/address_management/bloc/address_bloc.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/address_management/view/address_dialog.dart';
import 'package:edicion_limitada/features/address_management/widget/address_card.dart';
import 'package:edicion_limitada/features/checkout/bloc/checkout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressScreen extends StatefulWidget {
  final AddressModel? selectedAddress;
  
  const AddressScreen({
    Key? key, 
    this.selectedAddress,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.selectedAddress;
    context.read<AddressBloc>().add(LoadAddressesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
        actions: [
          TextButton(
            onPressed: _selectedAddress != null 
              ? () {
                context.read<CheckoutBloc>().add(SelectAddressEvent(_selectedAddress!));
                Navigator.pop(context, _selectedAddress);
              }
              : null,
            child: const Text('Confirm'),
          ),
        ],
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddressLoadedState) {
            if (state.addresses.isEmpty) {
              return const Center(
                child: Text('No addresses found. Add your first address!'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                final isSelected = _selectedAddress?.id == address.id;
                
                return InkWell(
                  onTap: () => setState(() => _selectedAddress = address),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AddressCard(
                      address: address,
                      showSelection: false,  // Change this to false to show edit/delete buttons
                      isSelected: isSelected,
                      onEdit: () => _showAddressDialog(context, address: address),
                      onDelete: () => _showDeleteDialog(context, address),
                    ),
                  ),
                );
              },
            );
          } else if (state is AddressErrorState) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddressDialog(BuildContext context, {AddressModel? address}) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<AddressBloc>(context),
        child: AddressDialog(
          address: address,
          onSave: (newAddress) {
            if (address == null) {
              // Adding new address
              context.read<AddressBloc>().add(AddAddressEvent(newAddress));
            } else {
              // Updating existing address
              context.read<AddressBloc>().add(
                UpdateAddressEvent(address.id!, newAddress),
              );
            }
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AddressModel address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text(
          'Are you sure you want to delete this address?\n\n'
          '${address.name}\n'
          '${address.street}\n'
          '${address.city}, ${address.state}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AddressBloc>().add(
                DeleteAddressEvent(address.id!),
              );
              Navigator.pop(context);
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