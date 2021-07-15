import 'dart:convert';

import 'package:star_wars/model/people_model.dart';
import 'package:star_wars/utils/shared_value.dart';
import 'package:http/http.dart' as http;

class PeopleService{
  Future<List<PeopleModel>> getPeople() async {

    Uri url = Uri.parse(API_URL);
    var response = await http.get(url);

    if (response.statusCode != 200) {
      return [];
    }

    // final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    // print(parsed);
    // return parsed.map<PeopleModel>((json) => PeopleModel.fromMap(json)).toList();

    // return json.decode(response.body)['results'];

    List jsonResponse = json.decode(response.body)['results'];
    return jsonResponse.map((data) => new PeopleModel.fromMap(data)).toList();
  }
}