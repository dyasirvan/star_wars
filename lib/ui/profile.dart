import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_wars/service/auth_services.dart';
import 'package:star_wars/ui/sign_in.dart';
import 'package:star_wars/utils/shared_value.dart';

class ProfilePage extends StatefulWidget{
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  SharedPreferences? preferences;

  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {});
    });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("Profile"),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${this.preferences?.getString(EXTRA_DISPLAY_NAME)}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900
                  ),
                ),
                SizedBox(height: 16,),
                Text('${this.preferences?.getString(EXTRA_EMAIL)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('${this.preferences?.getString(EXTRA_PHOTO_URL)}'),
                    radius: 20,
                  ),
                ),
                SizedBox(height: 24,),
                !isLoading
                    ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.redAccent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),
                    onPressed: () async{
                      await AuthServices.signOut(context: context);
                      removeDataLogin();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                        return SignInPage();
                      }));
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ))
                    : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue)
                )
              ],
            )
        )
    );
  }

  removeDataLogin() async{
    var pref = await SharedPreferences.getInstance();
    pref.remove(EXTRA_EMAIL);
    pref.remove(EXTRA_DISPLAY_NAME);
    pref.remove(EXTRA_PHOTO_URL);
  }
}