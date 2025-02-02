part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent{

}

class AddTOFavoritesEvent extends FavoriteEvent{
  final String productId;

  const AddTOFavoritesEvent(this.productId);
}

class RemoveFromFavoritesEvent extends FavoriteEvent {
  final String productId;
  const RemoveFromFavoritesEvent(this.productId);
}

class CheckFavoriteStatusEvent extends FavoriteEvent {
  final String productId;
  const CheckFavoriteStatusEvent(this.productId);
}

class UpdateFavoritesEvent extends FavoriteEvent {
  final List<String> favoriteIds;
  const UpdateFavoritesEvent(this.favoriteIds);

  
}
