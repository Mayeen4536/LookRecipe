class RecipeModel {
  String label;
  String image;
  String source;
  String url;

  RecipeModel({this.label, this.source, this.image, this.url});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
      url: parsedJson['url'],
      label: parsedJson['label'],
      image: parsedJson['image'],
      source: parsedJson['source'],
    );
  }
}
