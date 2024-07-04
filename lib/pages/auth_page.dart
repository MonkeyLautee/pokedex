import 'package:flutter/material.dart';
import '../services/helper.dart';
import '../widgets/my_text_field.dart';
import '../widgets/my_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

	late final TextEditingController _email;
	late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
		_password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
		_password.dispose();
    super.dispose();
  }

  void _signIn(BuildContext context)async{
  	String email = _email.text.trim().toLowerCase();
  	String password = _password.text.trim();
  	if(email.length < 5){
  		alert(context, 'Invalid email');
  		return;
  	}
  	if(password.length < 5){
  		alert(context, 'Invalid password');
  		return;
  	}
		// Do something
		doLoad(context);
		try{
			await Future.delayed(const Duration(seconds:1));
		} catch(e) {
			await alert(context,'An error happened');
		} finally {
			Navigator.pop(context);
		}
		Navigator.pop(context);
  }
	void _signUp(BuildContext context)async{
		// Do something
	}
	void _forgotPassword(BuildContext context)async{
		String? email = await prompt(context,text:'Email',type:TextInputType.emailAddress);
		if(email==null)return;
		// Do something
		doLoad(context);
		try{
			await Future.delayed(const Duration(seconds:1));
		} catch(e) {
			await alert(context,'An error happened');
		} finally {
			Navigator.pop(context);
		}
		alert(context,'Recovery email sent');
	}

	Future<String?> prompt(BuildContext context, {String text='', TextInputType type=TextInputType.text})async{
	  bool okButtonPressed=false;
	  final TextEditingController stringController = TextEditingController();
	  await showDialog(
	    context:context,
	    barrierDismissible:true,
	    builder:(context)=>SimpleDialog(
	      backgroundColor: Theme.of(context).colorScheme.surface,
	      contentPadding:const EdgeInsets.all(10.0),
	      title:text==''?null:Text(text,style:TextStyle(fontSize:17,color:Theme.of(context).colorScheme.onSurface)),
	      children:<Widget>[
	        TextField(
	          style:TextStyle(color:Theme.of(context).colorScheme.onSurface),
	          keyboardType:type,
	          maxLines:type==TextInputType.multiline?null:1,
	          textCapitalization:TextCapitalization.sentences,
	          controller:stringController,
	          autofocus:true,
	        ),
	        const SizedBox(height:14),
	        Row(
	          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
	          children:<Widget>[
	            ElevatedButton(
	              style:ButtonStyle(
	                backgroundColor:MaterialStateProperty.all(Theme.of(context).primaryColor),
	              ),
	              child: Padding(
	                padding: const EdgeInsets.symmetric(horizontal:12),
	                child: Text('Ok',style:TextStyle(fontSize:16,color:Theme.of(context).colorScheme.onPrimary)),
	              ),
	              onPressed:(){
	                okButtonPressed=true;
	                Navigator.pop(context);
	              },
	            ),
	            ElevatedButton(
	              style:ButtonStyle(
	                backgroundColor:MaterialStateProperty.all(Theme.of(context).primaryColor),
	              ),
	              child: Padding(
	                padding: const EdgeInsets.symmetric(horizontal:12),
	                child: Text('Cancel',style:TextStyle(fontSize:16,color:Theme.of(context).colorScheme.onPrimary)),
	              ),
	              onPressed:(){
	                Navigator.pop(context);
	              },
	            ),
	          ],
	        ),
	      ],
	    ),
	  );
	  return okButtonPressed?stringController.text.trim():null;
	}

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
    	backgroundColor:Theme.of(ctx).colorScheme.primary,
      body: SafeArea(
      	child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          	const SizedBox(height: 36),
          	Image.asset('assets/logo.png',height:200),
          	const SizedBox(height: 36),
          	MyTextField(
          		_email,
							leading: Icon(Icons.email,color:secColor(context)),
          		hint: 'Email',
          	),
          	const SizedBox(height: 16),
          	MyTextField(
          		_password,
							leading: Icon(Icons.key,color:secColor(context)),
          		hint: 'Password',
          	),
          	const SizedBox(height: 16),
          	MyButton('Sign in',()=>_signIn(context),color:Colors.blueAccent),
          	const SizedBox(height: 16),
          	MyButton('Sign up',()=>_signUp(context),color:secColor(context)),
          	const SizedBox(height: 22),
          	InkWell(
          		onTap: ()=>_forgotPassword(context),
          		child: const Text(
          			'Forgot password',
          			style: TextStyle(
          				color: Colors.white,
          				decoration: TextDecoration.underline,
          				decorationColor: Colors.white,
          			),
          			textAlign: TextAlign.center,
          		),
          	),
          ],
        ),
      ),
    );
  }
}