import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    precacheImage( AssetImage('images/BWallet.png'), context);

    return FutureBuilder<CreditsDataToLoad>(
      future: loadCreditsData(),
      builder: (BuildContext context, AsyncSnapshot<CreditsDataToLoad> snapshot){
        if(snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Info & Crediti"),
            ),
            body: ListView(
              children: <Widget>[
                Image(image: AssetImage('images/BWallet.png')),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 72),
                  title: Text("Versione dell'app"),
                  subtitle: Text(snapshot.hasData ? snapshot.data.packageInfo.version :""),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 72),
                  title: Text("Numero di build"),
                  subtitle: Text(snapshot.data.packageInfo.buildNumber),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 72),
                  title: Text("Link GitHub"),
                  subtitle: Text("github.com/bonfry/BonfryWallet"),
                  onTap: () async{
                    await launch("https://github.com/bonfry/BonfryWallet");
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 72),
                  title: Text("Pagina sviluppatore"),
                  subtitle: Text("bonfry.com"),
                  onTap: () async{
                    await launch("https://bonfry.com");
                  },
                ),
              ],
            ),
          );
        }else{
          return null;
        }
      }
    );
  }

  Future<CreditsDataToLoad> loadCreditsData() async{
    var packageInfo = await PackageInfo.fromPlatform();

    return CreditsDataToLoad(
      packageInfo: packageInfo
    );

  }
}

class CreditsDataToLoad{
  PackageInfo packageInfo;
  Image creditsImage;

  CreditsDataToLoad({this.packageInfo,this.creditsImage});
}
