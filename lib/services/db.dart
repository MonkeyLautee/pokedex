import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

Future<Map?> doHttpGet(String url) async {
  http.Response res;
  res = await http.get(Uri.parse(url));
  if (res.statusCode >= 200 && res.statusCode < 300) {
    return json.decode(res.body);
  } else {
    throw Exception('Failed to perform GET request in $url');
  }
}

class DB {

  static Future<List> getAllPokemons()async{
    List? pokemonsNames = Hive.box('cache').get('All names');
    if(pokemonsNames!=null){
      return pokemonsNames;
    }
    Map? res = await doHttpGet('https://pokeapi.co/api/v2/pokemon?limit=10000');
    if(res==null)throw 'Response was null';
    List names = (res['results'] as List).map((x)=>x['name']).toList();
    await Hive.box('cache').put('All names',names);
    return names;
  }

  static Future<Map> getPokemonData(String pokemonName)async{
    Map? pokemonData = Hive.box('cache').get(pokemonName);
    if(pokemonData!=null){
      return pokemonData;
    }
    Map? res = await doHttpGet('https://pokeapi.co/api/v2/pokemon/$pokemonName');
    if(res==null)throw 'Response was null';
    pokemonData = {
      'id': res['id'],
      'name': res['name'],
      'height': res['height'],
      'weight': res['weight'],
      'abilities': res['abilities'].map((x)=>x['ability']['name']).toList(),
      'stats': res['stats'].map((x){
        Map theStat = {};
        theStat[x['stat']['name']] = x['base_stat'];
        return theStat;
      }).toList(),
    };
    Hive.box('cache').put(pokemonName,pokemonData);
    return pokemonData;
  }

  static Future<List<Map>> getPopularPokemons()async{
    List<String> popularPokemonsNames = ['pikachu','charizard','bulbasaur','squirtle','eevee','jigglypuff'];
    List<Map> pokemonsData = [];
    for(int pokIndex = 0; pokIndex < popularPokemonsNames.length; pokIndex++){
      String pokName = popularPokemonsNames[pokIndex];
      Map pokData = await getPokemonData(pokName);
      pokemonsData.add(pokData);
    }
    return pokemonsData;
  }

  static String getPokemonImageUrl(String pokemonID){
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonID.png';
  }
  
}