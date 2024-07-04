import 'package:flutter/material.dart';

Future<dynamic> goTo(BuildContext context,Widget p)async=>await Navigator.push(context,MaterialPageRoute(builder:(x)=>p));

Color primColor(BuildContext context)=>Theme.of(context).colorScheme.primary;

Color secColor(BuildContext context)=>Theme.of(context).colorScheme.secondary;

void doLoad(BuildContext context){
  showDialog(
    context: context,
    builder: (context){
      return PopScope(
        canPop: false,
        child: AbsorbPointer(
          absorbing: true,
          child: Center(
            child: Material(
              type:MaterialType.transparency,
              child:CircularProgressIndicator(color:Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
      );
    }
  );
}

Future<void> alert(BuildContext context,String message)async{
  await showDialog(
    context:context,
    barrierDismissible: true,
    builder:(context){
      return SimpleDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title:Text(message,style:TextStyle(fontSize:17,color:Theme.of(context).colorScheme.onSurface),textAlign:TextAlign.center),
        children:[
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children:[
              ElevatedButton(
                onPressed:()=>Navigator.pop(context),
                style:ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                ),
                child:Padding(
                  padding: const EdgeInsets.symmetric(horizontal:32),
                  child: Text('Ok',style:TextStyle(color:Theme.of(context).colorScheme.onPrimary)),
                ),
              ),
            ],
          ),
        ],
      );
    }
  );
}

Future<bool?> confirm(BuildContext context, String question)async{
  bool? answer;
  await showDialog(
    context: context,
    barrierDismissible:true,
    builder: (context){
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(question,style:TextStyle(fontSize:17,color:Theme.of(context).colorScheme.onSurface)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style:ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10),
                  child: Text('Yes',style:TextStyle(fontSize:17,color:Theme.of(context).colorScheme.onPrimary)),
                ),
                onPressed: (){
                  answer = true;
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width:16),
              ElevatedButton(
                style:ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10),
                  child: Text('No',style:TextStyle(fontSize:17,color:Theme.of(context).colorScheme.onPrimary)),
                ),
                onPressed: (){
                  answer = false;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      );
    },
  );
  return answer;
}