import 'dart:convert';


import 'package:cek_grammer_plagiat/api/model/gramer_model.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    var text = "My mother are a doctor, but my father is a angeneer. I has a gun.";
    var uri = Uri.https('textgears-textgears-v1.p.rapidapi.com', '/grammar');
    final response = await http.post(uri,body: text, headers: {
      "X-RapidAPI-Host": "textgears-textgears-v1.p.rapidapi.com",
      "X-RapidAPI-Key": "16b135edb3msh00c790827c5ada6p110cf9jsna3837662f4eb",
      
    });

    // ignore: unused_local_variable
    Map data = jsonDecode(response.body);

    List temp = [];

    return Grammer.recipesFromSnapshot(temp);
  }
}