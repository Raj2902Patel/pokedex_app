import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokemonModel.dart';
import 'package:pokedex/services/DatabaseServices.dart';
import 'package:pokedex/services/httpServices.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HTTPService httpServices = GetIt.instance.get<HTTPService>();
  Response? res = await httpServices.get(url);

  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data!);
  }
  return null;
});

final favouritePokemonProvider =
    StateNotifierProvider<FavouritePokemonProvider, List<String>>((ref) {
  return FavouritePokemonProvider([]);
});

class FavouritePokemonProvider extends StateNotifier<List<String>> {
  final DatabaseServices _databaseServices =
      GetIt.instance.get<DatabaseServices>();

  String FAVOURITE_POKEMON_LIST_KEY = "FAVOURITE_POKEMON_LIST_KEY";

  FavouritePokemonProvider(
    super._state,
  ) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? result =
        await _databaseServices.getList(FAVOURITE_POKEMON_LIST_KEY);
    state = result ?? [];
  }

  void addFavouritePokemon(String url) {
    state = [...state, url];
    _databaseServices.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }

  void removeFavouritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseServices.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }
}
