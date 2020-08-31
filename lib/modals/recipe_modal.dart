class RecipeModal{
  String label;
  String image;
  String url;
  String source;

  RecipeModal({this.label, this.image, this.url, this.source});


   factory RecipeModal.fromMap(Map<String,dynamic> parsedJson) {
     return RecipeModal(
       url: parsedJson['url'],
       label: parsedJson['label'],
       image: parsedJson['image'],
       source: parsedJson['source']
     );
   }

}