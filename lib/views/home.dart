import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reciepieapp/modals/recipe_modal.dart';
import 'package:reciepieapp/views/recipie.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<RecipeModal> recipes = new List<RecipeModal>();

  TextEditingController inputIngredientsTEC = new TextEditingController();

  String applicationId = "11459a71";
  String applicationKey = "73e28110a11bf49ad5bb2c9bb884b409";

  getRecipes(String query) async{
    String url =  "https://api.edamam.com/search?q=$query&app_id=11459a71&app_key=73e28110a11bf49ad5bb2c9bb884b409";


      var response = await http.get(url);

      Map<String,dynamic> jsonData = jsonDecode(response.body);



      jsonData["hits"].forEach((element){
        print(element.toString());
        RecipeModal recipeModal  = new  RecipeModal();

        recipeModal = RecipeModal.fromMap(element['recipe']);
        recipes.add(recipeModal);

      });

      setState(() {

      });

      print(recipes.toString());





  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xff213A50),
                    const Color(0xff071930)
                  ]
                )
              ),
            ),


            SingleChildScrollView(
              child: Container(

                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("AppGuy",style:
                        TextStyle(
                            fontSize: 18,
                            color: Colors.white,

                          )
                        ),
                        Text("Recipes",style: TextStyle(
                         color: Colors.blue,
                            fontSize: 18
                        ))
                      ],
                    ),

                    SizedBox(height: 30,),
                    Text('What will you cook today?',
                    style: TextStyle(fontSize: 20,color: Colors.white),),
                    Text(
                      'Just Enter Ingredients you have and we will show the best dish to cook.',
                      style: TextStyle(fontSize: 15,color: Colors.white),
                    ),

                    SizedBox(height: 30,),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: inputIngredientsTEC,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Enter Ingredients",
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18
                                )
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              if(inputIngredientsTEC.text.isNotEmpty) {
                                  getRecipes(inputIngredientsTEC.text.toString());
                              }
                              else{
                                   print("Field is empty");
                              }
                          },
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.orange,

                            ),

                              child: Icon(Icons.search,color: Colors.white,)),
                        )
                      ],
                    ),

                    SizedBox(height: 30,),
                    Container(
                      child: GridView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 10.0,

                          ),
                          children: List.generate(recipes.length, (index) {

                            return GridTile(
                              child: RecipieTile(
                                title: recipes[index].label,
                                desc: recipes[index].source,
                                imgUrl: recipes[index].image,
                                url: recipes[index].url,
                              ),
                            );
                            
                          })
                      ),
                    ),
                  ],
                ),
              ),
            ),








          ],
        ),
      )



    );




  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  GradientCard(
      {this.topColor,
        this.bottomColor,
        this.topColorCode,
        this.bottomColorCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [topColor, bottomColor],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight)),
                ),
                Container(
                  width: 180,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          topColorCode,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          bottomColorCode,
                          style: TextStyle(fontSize: 16, color: bottomColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

