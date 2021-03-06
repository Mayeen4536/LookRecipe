import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lookforrecipe/models/recipe_model.dart';
import 'package:lookforrecipe/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: deprecated_member_use
  List<RecipeModel> recipes = new List<RecipeModel>();
  TextEditingController textEditingController = new TextEditingController();
  String applicationId = 'd1b3355c';
  String applicationKey = '439378a38169dd2eae2bd0a2e8512e3f';

  getRecipes(String query) async {
    String url =
        'https://api.edamam.com/search?q=$query&app_id=d1b3355c&app_key=439378a38169dd2eae2bd0a2e8512e3f';

    var response = await http.get(Uri.parse(url));

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    // ignore: unnecessary_statements
    jsonData['hits'].forEach((element) {
      print(element.toString());

      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);
      recipes.add(recipeModel);
    });

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          const Color(0xff213A50),
          const Color(0xff071930),
        ])),
      ),
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: !kIsWeb ? Platform.isIOS ? 60 : 40 : 40, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Text(
                    'Look',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    'Recipes',
                    style: GoogleFonts.overpass(textStyle: TextStyle(
                        color: Colors.yellow,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'What are you planning to Cook?',
                style: GoogleFonts.overpass(textStyle: (TextStyle(fontSize: 18, color: Colors.white)
              ),),),
              SizedBox(
                height: 8,
              ),
              Text(
                'Just enter the ingredient you want to use and we will show you the recipes',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Enter any Ingredient',
                          hintStyle: TextStyle(
                              fontSize: 15, color: Colors.white.withOpacity(0.5)),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    InkWell(
                      onTap: () {
                        if (textEditingController.text.isNotEmpty) {
                          getRecipes(textEditingController.text);
                        } else {}
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: GridView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisSpacing: 10.0),
                  children: 
                    List.generate(recipes.length, (index) {
                      return GridTile(
                        child: RecipieTile(
                          title: recipes[index].label,
                          desc: recipes[index].source,
                          imgUrl: recipes[index].image,
                          url: recipes[index].url, 
                      
                        ),
                      );
                    })
                  ,
                  ),
              )
            ],
          ),
        ),
      ),
    ]));
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

