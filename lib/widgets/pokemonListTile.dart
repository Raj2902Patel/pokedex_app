import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemonModel.dart';
import 'package:pokedex/providers/pokemonDataProviders.dart';
import 'package:pokedex/widgets/pokemonStatsCard.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURl;
  late FavouritePokemonProvider _favouritePokemonProvider;
  late List<String> _favouritePokemon;
  PokemonListTile({super.key, required this.pokemonURl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favouritePokemonProvider = ref.watch(favouritePokemonProvider.notifier);
    _favouritePokemon = ref.watch(favouritePokemonProvider);

    final pokemon = ref.watch(pokemonDataProvider(pokemonURl));
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Center(
        child: Text(
          "Error: ${error.toString()}",
        ),
      );
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCard(pokemonURL: pokemonURl);
              },
            );
          }
        },
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
              : const CircleAvatar(),
          title: Text(pokemon != null
              ? pokemon.name!.toUpperCase()
              : "Loading Names... "),
          subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} Moves"),
          trailing: IconButton(
            onPressed: () {
              if (_favouritePokemon.contains(pokemonURl)) {
                _favouritePokemonProvider.removeFavouritePokemon(pokemonURl);
              } else {
                _favouritePokemonProvider.addFavouritePokemon(pokemonURl);
              }
            },
            icon: _favouritePokemon.contains(pokemonURl)
                ? const Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  )
                : const Icon(
                    CupertinoIcons.heart,
                  ),
          ),
        ),
      ),
    );
  }
}
