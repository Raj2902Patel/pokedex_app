import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/controllers/homeController.dart';
import 'package:pokedex/models/pageData.dart';
import 'package:pokedex/models/pokemonModel.dart';
import 'package:pokedex/providers/pokemonDataProviders.dart';
import 'package:pokedex/widgets/pokemonCard.dart';
import 'package:pokedex/widgets/pokemonListTile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(
    HomePageData.initial(),
  );
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonListScrollController = ScrollController();

  late HomePageController _homeController;
  late HomePageData _homePageData;

  late List<String> _favouritePokemon;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListener);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonListScrollController.offset ==
            _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homeController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    _homeController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favouritePokemon = ref.watch(favouritePokemonProvider);

    return SafeArea(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favouritePokemonList(context),
              _allPokemonList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favouritePokemonList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18),
            child: Text(
              "Favourites",
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_favouritePokemon.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _favouritePokemon.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        String pokemonUrl = _favouritePokemon[index];
                        return PokemonCard(pokemonUrl: pokemonUrl);
                      },
                    ),
                  ),
                if (_favouritePokemon.isEmpty)
                  const Center(
                    child: Text("No Favourites Pokemon Found!"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18),
            child: Text(
              "All Pokemons",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
              controller: _allPokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonURl: pokemon.url!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
