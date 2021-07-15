
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_wars/service/auth_services.dart';
import 'package:star_wars/ui/home.dart';
import 'package:star_wars/ui/people.dart';
import 'package:star_wars/utils/shared_value.dart';

class SignInPage extends StatefulWidget{
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40,),
                Text("Hello.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5
                  ),
                ),
                // tulisan welcome back
                Text("Welcome Back",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 36,
                      letterSpacing: 5
                  ),
                ),
                SizedBox(height: 250,),
                FutureBuilder(
                    future: AuthServices.initializeFirebase(context: context),
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Text("");
                      }else if(snapshot.connectionState == ConnectionState.done){
                        return GoogleSignInButton();
                      }

                      return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue)
                        ),
                      );
                    },
                )
              ],
            ),
          )),
    );
  }

}

class GoogleSignInButton extends StatefulWidget{
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool isLoading = false;
  SharedPreferences? preferences;

  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {});
    });
  }

  void save(String email, String displayName, String photoUrl) async{
    setState(() {
      this.preferences?.setString(EXTRA_EMAIL, email);
      this.preferences?.setString(EXTRA_DISPLAY_NAME, displayName);
      this.preferences?.setString(EXTRA_PHOTO_URL, photoUrl);
    });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return !isLoading ? Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try{
            User? user = await AuthServices.signInWithGoogle(context: context);
            if(user != null){
              save(
                  user.email!,
                  user.displayName!,
                  user.photoURL!
              );

              print(user.email);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return HomePage();
              }));
            }

          }catch(e){
            if(e is FirebaseAuthException){
              showMessage(e.message!);
            }
          }
          setState(() {
            isLoading = false;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/search.png", width: 24, height: 24,),
            SizedBox(width: 8,),
            Text(
                'Login with Google'
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.black,
            primary: Colors.white,
            side: BorderSide(color: Colors.black, width: 1),
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
        ),
      ),
    ): Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue)
      ),
    );
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
