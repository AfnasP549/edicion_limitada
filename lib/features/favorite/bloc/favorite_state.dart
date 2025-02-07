part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();
  
  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}

class FavoriteLodingState extends FavoriteState{}

class FavoriteLoadedState extends FavoriteState {
  final List<String> favoriteIds;
  final Map<String, bool> favoriteStatus;
  final String? removedProductName;

  const FavoriteLoadedState({
    required this.favoriteIds,
    required this.favoriteStatus,
    this.removedProductName,
  });

  
}


class FavoriteErrorState extends FavoriteState{
  final String error;

  const FavoriteErrorState(this.error);
}
