// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class RecipeWebView extends StatefulWidget {

  String Initialurl;
  RecipeWebView(this.Initialurl);

  @override
  State<RecipeWebView> createState() => _RecipeWebViewState();
}

class _RecipeWebViewState extends State<RecipeWebView> {
  late String completeUrl;

  var isLoading;

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    isLoading = true;

    if (widget.Initialurl.toString().contains("http://")){
      completeUrl = widget.Initialurl.toString().replaceAll("http://","https://");
    }
    else{
      completeUrl = widget.Initialurl;
    }

    controller = WebViewController()..loadRequest(Uri.parse(completeUrl))..setJavaScriptMode(JavaScriptMode.unrestricted);
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: isLoading ? Center(child: CircularProgressIndicator()) : WebViewWidget(
              controller: controller,
            )
        )

    );
  }
}
