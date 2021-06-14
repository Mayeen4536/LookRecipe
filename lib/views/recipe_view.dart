import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;

  RecipeView({this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String finalUrl;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    if (widget.postUrl.contains("http//")) {
      finalUrl = widget.postUrl.replaceAll("http//", "https//");
    } else {
      finalUrl = widget.postUrl;
    }
    super.initState();
     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: Platform.isIOS ? 70 : 60,
                  right: 40,
                  left: 40,
                  bottom: 17),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                const Color(0xff213A50),
                const Color(0xff071930),
              ])),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Text(
                    'Look',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    'Recipes',
                    style: GoogleFonts.overpass(
                      textStyle: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                
                height: MediaQuery.of(context).size.height - (Platform.isIOS ? 104 : 102),
                width: MediaQuery.of(context).size.width,
                child: WebView(
                  initialUrl: widget.postUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    setState(() {
                      _controller.complete(webViewController);
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
