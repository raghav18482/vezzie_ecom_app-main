

class CarousleUrlModel{

  String imageUrl;
  String id;
  CarousleUrlModel({
    required this.imageUrl,
    required this.id
  });

  factory CarousleUrlModel.fromJson(json){
    return CarousleUrlModel(
imageUrl: json["image"],
id: json["id"]
    );
  }
}