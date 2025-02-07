import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/features/favorite/service/favorite_service.dart';
import 'package:equatable/equatable.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteService _favoriteService;
  StreamSubscription? _favoriteSubscription;
  FavoriteBloc(this._favoriteService) : super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddTOFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
    on<UpdateFavoritesEvent>(_onUpdateFavorites);

    add(LoadFavoritesEvent());
  }
//!Load
  void _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLodingState());
    try {
      await _favoriteSubscription?.cancel();
      _favoriteSubscription = _favoriteService.getFavoriteProductIds().listen(
        (favoriteIds) {
          add(UpdateFavoritesEvent(favoriteIds));
        },
        onError: (error) {
          emit(FavoriteErrorState(error.toString()));
        },
      );
    } catch (e) {
      emit(FavoriteErrorState('Failed to load favorites: ${e.toString()}'));
    }
  }

//!update
  void _onUpdateFavorites(
      UpdateFavoritesEvent event, Emitter<FavoriteState> emit) {
    emit(FavoriteLoadedState(
      favoriteIds: event.favoriteIds,
      favoriteStatus: {for (var id in event.favoriteIds) id: true},
    ));
  }

//!add
  void _onAddToFavorites(
      AddTOFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLodingState());
      await _favoriteService.addFavorites(event.productId);
    } catch (e) {
      emit(FavoriteErrorState('Failed to add favorite: ${e.toString()}'));
    }
  }

//!remove
  void _onRemoveFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLodingState());
      await _favoriteService.removeFromFavorites(event.productId);
    } catch (e) {
      emit(FavoriteErrorState('Failed to remove favorite: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _favoriteSubscription?.cancel();
    return super.close();
  }

  void _onCheckFavoriteStatus(
      CheckFavoriteStatusEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FavoriteLodingState());
      final isFavorite = await _favoriteService.isFavorite(event.productId);
      if (state is FavoriteLoadedState) {
        final currentState = state as FavoriteLoadedState;
        emit(FavoriteLoadedState(
          favoriteIds: currentState.favoriteIds,
          favoriteStatus: {
            ...currentState.favoriteStatus,
            event.productId: isFavorite,
          },
        ));
      }
    } catch (e) {
      emit(FavoriteErrorState('Failed to check Favorite${e.toString()}'));
    }
  }
}
