import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
class CowinAppScreen extends StatefulWidget {
  const CowinAppScreen({Key key}) : super(key: key);

  @override
  _CowinAppScreenState createState() => _CowinAppScreenState();
}

class _CowinAppScreenState extends State<CowinAppScreen> {
  @override
  bool showSpinner = true;

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Co-Win Mini App"),
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: primaryRed,
        ),
        color: Colors.white,
        inAsyncCall: showSpinner,
        child: WebView(
          initialUrl: "https://selfregistration.cowin.gov.in/",
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (finished){
            setState(() {
              showSpinner = false;
            });
          },
        ),
      ),
    );
  }
}
