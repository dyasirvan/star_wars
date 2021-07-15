import 'package:flutter/material.dart';
import 'package:star_wars/model/people_model.dart';
import 'package:star_wars/service/people_services.dart';
import 'package:star_wars/ui/detail.dart';

class PeoplePage extends StatefulWidget{
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  late Future<List<PeopleModel>> listPeople;
  PeopleService peopleService = new PeopleService();
  var type = "List";

  @override
  void initState() {
    super.initState();
    listPeople  = peopleService.getPeople();
    type = "List";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("Home"),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  if(type == "List") {
                    return PeopleList();
                  }else{
                    return PeopleGrid();
                  }
                },
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: (){
                  setState(() {
                    if(type == "List"){
                      type = "Grid";
                    }else{
                      type = "List";
                    }
                  });
                },
                child: Text("Change to List or Grid"),
              ),
            )
          ],
        )
    );
  }
}

class PeopleList extends StatefulWidget{

  @override
  _PeopleListState createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  late Future<List<PeopleModel>> listPeople;
  PeopleService peopleService = new PeopleService();

  @override
  void initState() {
    super.initState();
    listPeople  = peopleService.getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: FutureBuilder<List<PeopleModel>>(
        future: listPeople,
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<PeopleModel> dataPeople = snapshot.data;
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Card(
                        elevation: 2,
                        shape: Border(right: BorderSide(color: Colors.lightBlueAccent, width: 5)),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return DetailPeoplePage(data: dataPeople[index],);
                                }));
                              },
                              title: Text('${dataPeople[index].name}'),
                              subtitle: Text('${dataPeople[index].gender}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class PeopleGrid extends StatefulWidget{
  @override
  _PeopleGridState createState() => _PeopleGridState();
}

class _PeopleGridState extends State<PeopleGrid> {
  late Future<List<PeopleModel>> listPeople;
  PeopleService peopleService = new PeopleService();

  @override
  void initState() {
    super.initState();
    listPeople  = peopleService.getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: FutureBuilder<List<PeopleModel>>(
        future: listPeople,
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<PeopleModel> dataPeople = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                controller: new ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: dataPeople.map((people) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return DetailPeoplePage(data: people,);
                      }));
                    },
                    child: Container(
                      color: Colors.yellow,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(people.name),
                          Text(people.gender),
                        ],
                      ),
                    ),
                  );
                }).toList()
              ),
            );
          }else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}