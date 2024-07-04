import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/helper.dart';
import '../services/db.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

	final Box _cache = Hive.box('cache');
	List<Map> _pokemons = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      doLoad(context);
      try {
      	List names = _cache.get('favorites')??[];
      	List<Map> poks=[];
      	for(int i = 0; i < names.length; i++){
      		Map pokMap = await DB.getPokemonData(names[i]);
      		poks.add(pokMap);
      	}
      	setState(()=>_pokemons = poks);
      } catch(e) {
      	await alert(context,'An error happened');
      	print(e);
      } finally {
      	Navigator.pop(context);
      }
    });
  }

  void _removeFromFavorites(BuildContext context, String pokName)async{
  	bool? answer = await confirm(context,'Remove $pokName from favorites?');
  	if(answer!=true)return;
  	List favorites = _cache.get('favorites');
  	favorites.remove(pokName);
  	_cache.put('favorites',favorites);
  	setState((){
  		_pokemons.removeWhere((pok)=>pok['name']==pokName);
  	});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    	backgroundColor:Theme.of(context).colorScheme.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
        	Text(
            'Favorite Pokemons',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primColor(context),
              fontSize: 23,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        	Visibility(
            visible: _pokemons.isNotEmpty,
            child: Column(
              children: _pokemons.map((Map pok)=>Card(
                elevation: 5.5,
                color: secColor(context),
                child: ListTile(
                  leading: Image.network(
                    DB.getPokemonImageUrl(pok['id'].toString()),
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Image.asset('assets/logo.png',height:42);
                    },
                  ),
                  trailing: IconButton(
                  	onPressed: ()=>_removeFromFavorites(context,pok['name']),
                  	icon: const Icon(Icons.delete,color:Colors.white,size:32),
                  ),
                  title: Text(
                    pok['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Abilities: ${pok['abilities'].length}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}