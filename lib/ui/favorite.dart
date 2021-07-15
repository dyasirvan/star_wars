import 'package:flutter/material.dart';
import 'package:star_wars/db/people_database.dart';
import 'package:star_wars/model/db_model.dart';

class FavoritePage extends StatefulWidget{
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<DbModel> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future refreshData() async {
    setState(() => isLoading = true);

    this.data = await PeopleDatabase.instance.readAll();

    setState(() => isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Favorite"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : data.isEmpty
                ? Text("Data kosong")
                : callListFavoritePeople(),
        ),
      ),
    );
  }

  Widget callListFavoritePeople() => ListView.builder(
    itemCount: data.length,
    itemBuilder: (_, index){
      final people = data[index];
      return Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('${people.name}'),
              subtitle: Text('${people.gender}'),
              trailing: GestureDetector(
                  onTap: (){
                    _showDialog(context, people.id!);
                  },
                  child: Icon(Icons.delete)),
            ),
          ],
        ),
      );
    },
  );

  void _showDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert!!"),
          content: new Text("Are you sure want to delete this item ?"),
          actions: <Widget>[
            TextButton(
              child: new Text("Cancel", style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: new Text("OK", style: TextStyle(color: Colors.red),),
              onPressed: () async{
                await PeopleDatabase.instance.delete(id);
                Navigator.of(context).pop();
                refreshData();
              },
            ),
          ],
        );
      },
    );
  }
}