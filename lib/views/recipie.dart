import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

   String finalUrl;

   final Completer<WebViewController> controller  = Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState

    if(widget.postUrl.contains("http://")) {
         finalUrl = widget.postUrl.replaceAll("http://", "https://");
    }
    else{
      finalUrl = widget.postUrl;
    }


    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        const Color(0xff213A50),
                        const Color(0xff071930)
                      ]
                  )
              ),

              padding: EdgeInsets.only(top: 30,right: 20,left: 24,bottom: 0),

              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("AppGuy",style:
                  TextStyle(
                    fontSize: 18,
                    color: Colors.white,

                  )
                  ),
                  Text("Recipes",style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18
                  ))
                ],
              ),
            ),


            Container(
              height: MediaQuery.of(context).size.height-100,
              width: MediaQuery.of(context).size.width,

              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: finalUrl,
                onWebViewCreated: (WebViewController webViewController) {
                  setState(() {
                    controller.complete(webViewController);
                  });
                },
              ),
            )





          ],
        ),
      ),
    );
  }
}
