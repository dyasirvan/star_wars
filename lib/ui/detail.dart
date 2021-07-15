import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_wars/db/people_database.dart';
import 'package:star_wars/model/db_model.dart';
import 'package:star_wars/model/people_model.dart';
import 'package:star_wars/ui/home.dart';

class DetailPeoplePage extends StatefulWidget{
  final PeopleModel? data;

  const DetailPeoplePage({
    Key? key,
    this.data,
  }) : super(key: key);
  @override
  _DetailPeoplePageState createState() => _DetailPeoplePageState();
}

class _DetailPeoplePageState extends State<DetailPeoplePage> {
  late String name;
  late String height;
  late String mass;
  late String hairColor;
  late String skinColor;
  late String gender;

  @override
  void initState() {
    super.initState();

    name = widget.data?.name ?? '';
    mass = widget.data?.mass ?? '';
    height = widget.data?.height ?? '';
    hairColor = widget.data?.hairColor ?? '';
    skinColor = widget.data?.skinColor ?? '';
    gender = widget.data?.gender ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return HomePage();
              }));
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white,)),
        title: Text("Detail"),
        backgroundColor: Colors.lightBlue,
        actions: [
          GestureDetector(
              onTap: () async{
                await addFavorite();
                Navigator.of(context).pop();
              },
              child: Icon(Icons.favorite, color: Colors.white,))
        ],
      ),
      body: Center(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Name : $name"),
            Text("Height : $height cm"),
            Text("Mass : $mass kg"),
            Text("Hair Color : $hairColor"),
            Text("Skin Color : $skinColor"),
            Text("Gender : $gender"),
          ],
        )
      ),
    );
  }

  Future addFavorite() async {
    final data = DbModel(
      name: name,
      gender: gender
    );

    await PeopleDatabase.instance.create(data);
  }
}