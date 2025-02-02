part of 'address_bloc.dart';

sealed class AddressState extends Equatable {
  const AddressState();
  
  @override
  List<Object> get props => [];
}

final class AddressInitialState extends AddressState {}

class AddressLoadingState extends AddressState{}

class AddressLoadedState extends AddressState{
  final List<AddressModel> addresses;

  const AddressLoadedState(this.addresses);
  
}

class AddressErrorState extends AddressState{
  final String message;

  const AddressErrorState(this.message);
}

