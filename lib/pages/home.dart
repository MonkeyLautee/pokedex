import 'package:flutter/material.dart';
import '../services/helper.dart';
import '../services/db.dart';
import '../widgets/my_text_field.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Box _cache = Hive.box('cache');
  List<Map> _pokemons = [];
  List<Map> _pokemonsFound = [];
  late final TextEditingController _search;

  void _searchPokemon(BuildContext context)async{
    doLoad(context);
    try{
      String text = _search.text.trim().toLowerCase();
      if(text!=''){
        List names = await DB.getAllPokemons();
        List filteredNames = names.where((name)=>name.toLowerCase().contains(text)).toList();
        List<Map> poksFound = [];
        for(int i = 0; i < filteredNames.length; i++){
          Map pokMap = await DB.getPokemonData(filteredNames[i]);
          poksFound.add(pokMap);
        }
        setState(()=>_pokemonsFound = poksFound);
      }
    } catch(e) {
      await alert(context,'An error happened');
      print(e);
    } finally {
      Navigator.pop(context);
    }
  }

  void _pokemonMenu(BuildContext context, Map pok)async{
    int? option = await choose(context,['Add to favorites','Cancel']);
    if(option==0){
      List favorites = _cache.get('favorites')??[];
      if(!favorites.contains(pok['name'])){
        favorites.add(pok['name']);
        _cache.put('favorites',favorites);
      } else {
        alert(context, 'Pokemon already in the list');
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      doLoad(context);
      try{
        List<Map> data = await DB.getPopularPokemons();
        setState(()=>_pokemons=data);
      } catch(e) {
        await alert(context,'An error happened');
        print(e);
      } finally {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<int?> choose(BuildContext context,List<String> options,{Widget? child, Color? color, Color? bg})async{
    int? selectedIndex;
    List<Widget> dialogOptions=[];
    for(int c=0;c<options.length;c++){
      dialogOptions.add(
        SimpleDialogOption(
          child:Text(options[c],style:TextStyle(fontSize:16,color:color??Theme.of(context).colorScheme.onPrimary)),
          onPressed:(){
            selectedIndex=c;
            Navigator.pop(context);
          },
        ),
      );
    }
    if(child!=null)dialogOptions.add(child);
    await showDialog(
      context:context,
      barrierDismissible:true,
      builder:(context)=>SimpleDialog(backgroundColor:bg??Theme.of(context).colorScheme.primary,children:dialogOptions),
    );
    return selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Popular Pokemons',
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
                  onTap: ()=>_pokemonMenu(context,pok),
                  leading: Image.network(
                    DB.getPokemonImageUrl(pok['id'].toString()),
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Image.asset('assets/logo.png',height:42);
                    },
                  ),
                  trailing: const Icon(Icons.catching_pokemon,color:Colors.white,size:42),
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
          const SizedBox(height: 16),
          Text(
            'Search your pokemon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primColor(context),
              fontSize: 23,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          MyTextField(
            _search,
            hint: 'Search',
            leading: const Icon(Icons.search,color:Colors.red),
            onSubmitted: (x)=>_searchPokemon(context),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: _pokemonsFound.isNotEmpty,
            child: Column(
              children: _pokemonsFound.map((Map pok)=>Card(
                elevation: 5.5,
                color: secColor(context),
                child: ListTile(
                  onTap: ()=>_pokemonMenu(context,pok),
                  leading: Image.network(
                    DB.getPokemonImageUrl(pok['id'].toString()),
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Image.asset('assets/logo.png',height:42);
                    },
                  ),
                  trailing: const Icon(Icons.catching_pokemon,color:Colors.white,size:42),
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