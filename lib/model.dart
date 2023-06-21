class RecipeModel
{
  late String label;
  late String imgUrl;
  late double calories;
  late String url;


  RecipeModel({
    this.label = "LABEL",
    this.url  = "IMAGE",
    this.calories  = 0.00,
    this.imgUrl = "URL"
});

  factory RecipeModel.fromMap(Map recipe)
  {
    return RecipeModel(
        label: recipe["label"],
        calories: recipe["calories"],
        imgUrl: recipe["image"],
        url: recipe["url"]
    );
  }
}