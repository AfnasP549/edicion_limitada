part of 'address_bloc.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddressesEvent extends AddressEvent{}

class AddAddressEvent extends AddressEvent {
  final AddressModel address;
  const AddAddressEvent(this.address);
}

class UpdateAddressEvent extends AddressEvent {
  final String addressId;
  final AddressModel address;
  const UpdateAddressEvent(this.addressId, this.address);
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;
  const DeleteAddressEvent(this.addressId);
}

