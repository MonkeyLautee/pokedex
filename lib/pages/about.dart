import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/helper.dart';

class About extends StatefulWidget {
  const About({super.key});
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setBackgroundColor(const Color(0x00000000));
    _controller.enableZoom(true);
    _controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (int progress) {},
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
      onUrlChange: (UrlChange change) {},
      onHttpAuthRequest: (HttpAuthRequest request) {},
    ));
    WidgetsBinding.instance.addPostFrameCallback((_){
      _controller.loadRequest(Uri.parse('https://pokeapi.co'));
      alert(context,'To activate custom dark mode press the floating button at the right bottom');
    });
  }

  void _activateDarkTheme(context)async{
  	bool? ans = await confirm(context,'Activate dark mode?');
  	if(ans!=true)return;
  	// JavaScript code to make the website dark
  	_controller.runJavaScript('const c=(tag,attr)=>{const e=document.createElement(tag);attr.forEach(a=>e.setAttribute(a.split("=")[0],a.substring(a.indexOf("=")+1)));return e};const at=(e,t)=>e.appendChild(document.createTextNode(t));const za=(id,code)=>{if(!document.getElementById(id)){document.querySelectorAll("head")[0].appendChild(c("style",[`id=\${id}`]));at(document.getElementById(id),code)}};za("my-dark","*{background-color:black !important;color:white !important}a{color:skyblue !important;text-decoration:underline !important}");');
  }

  @override
  Widget build(BuildContext context)=>PopScope(
    canPop: false,
    onPopInvoked:(bool didPop)async{
      if(didPop)return;
      if((await _controller.canGoBack())){
        _controller.goBack();
      } else {
        Navigator.pop(context);
      }
    },
    child: Scaffold(
    	floatingActionButton: FloatingActionButton(
		    onPressed: ()=>_activateDarkTheme(context),
		    child: const Icon(Icons.dark_mode,color:Colors.white),
		  ),
      body: SafeArea(
        child: WebViewWidget(controller:_controller),
      ),
    ),
  );
}