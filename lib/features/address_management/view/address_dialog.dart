import 'package:edicion_limitada/features/address_management/bloc/address_bloc.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressDialog extends StatefulWidget {
  final AddressModel? address;
  final Function(AddressModel)? onSave;  // Add this parameter

  const AddressDialog({
    Key? key, 
    this.address,
    this.onSave,  // Add this to constructor
  }) : super(key: key);

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name);
    _phoneController = TextEditingController(text: widget.address?.phoneNumber);
    _streetController = TextEditingController(text: widget.address?.street);
    _cityController = TextEditingController(text: widget.address?.city);
    _stateController = TextEditingController(text: widget.address?.state);
    _pincodeController = TextEditingController(text: widget.address?.pincode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final address = AddressModel(
        id: widget.address?.id, // Preserve the original ID
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        pincode: _pincodeController.text,
        isDefault: widget.address?.isDefault ?? false,
      );

      if (widget.onSave != null) {
        widget.onSave!(address);
      } else {
        if (widget.address != null) {
          // Update existing address
          context.read<AddressBloc>().add(
            UpdateAddressEvent(widget.address!.id!, address),
          );
        } else {
          // Add new address
          context.read<AddressBloc>().add(AddAddressEvent(address));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressLoadedState) {
          Navigator.of(context).pop();
        } else if (state is AddressErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter name' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter phone number' : null,
                ),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(labelText: 'Street Address'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter street address' : null,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter city' : null,
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter state' : null,
                ),
                TextFormField(
                  controller: _pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter pincode' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is AddressLoadingState
                    ? null
                    : _handleSave,
                child: state is AddressLoadingState
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.address == null ? 'Add' : 'Update'),
              );
            },
          ),
        ],
      ),
    );
  }
}