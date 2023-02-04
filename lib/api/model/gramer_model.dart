import 'dart:convert';

Grammer? grammerFromJson(String str) => Grammer.fromJson(json.decode(str));



class Recipe {
  String? type;
  Properties? properties;

  Recipe(
      {required this.type,
      required this.properties,
     });

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
        type: json['type'] as String,
        properties: json['properties'],
    );
  }
  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe { type: $type, properties:$properties}';
  }
}

class Grammer {
  String? type;
  Properties? properties;

  Grammer(
      {required this.type,
      required this.properties,
     });

  factory Grammer.fromJson(dynamic json) {
    return Grammer(
        type: json['type'] as String,
        properties: json['properties'],
    );
  }
  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe { type: $type, properties:$properties}';
  }
}

class Properties {
  Properties({
    this.response,
    this.status,
  });

  Response? response;
  Response? status;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        response: Response.fromJson(json["response"]),
        status: Response.fromJson(json["status "]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "status ": status!.toJson(),
      };
}

class Response {
  Response({
    this.type,
  });

  String? type;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}
