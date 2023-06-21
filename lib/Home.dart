import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lost_recipes/Search.dart';

import 'model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  TextEditingController searchCtrl = TextEditingController();
  List<RecipeModel> recipeList = <RecipeModel>[];
  //TextEditingController searchController = new TextEditingController();
  List reciptCatList = [
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Chinese"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "North Indian"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Desserts"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Continental"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "South Indian"
    },
    {
      "imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db",
      "heading": "Healthy Food"
    }
  ];
  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=ebb6041c&app_key=3c33ad913ab23b8554082bfb5fdd78b5";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        log(recipeList.toString());
      });
    });
    recipeList.forEach((Recipe) {
      print(Recipe.label);
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipe("Ladoo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xffffffe0),
            Color(0xfffafad2),
          ])),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "What do you want to cook today ?",
                        style: TextStyle(
                            fontSize: 32, fontFamily: 'PlayfairDisplay'),
                      ),
                    ],
                  )),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Color(0xfffffff1),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (searchCtrl.text.replaceAll(" ", "") == "") {
                            print("Blank");
                          } else {
                            getRecipe(searchCtrl.text);
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.lightGreen,
                          ),
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchCtrl,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Find your recipes here ",
                              suffixStyle:
                                  TextStyle(fontStyle: FontStyle.normal)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  height: 150,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reciptCatList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Search(reciptCatList[index]['heading']),));
                          },
                          child: Card(
                            margin: EdgeInsets.all(20),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  child: Image.network(reciptCatList[index]['imgUrl'],
                                    fit: BoxFit.fill,
                                    height: 200,
                                    width: 200,),
                                  borderRadius: BorderRadius.circular(14),
                                ),

                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.black26,
                                        ),
                                        child: Text(reciptCatList[index]['heading'],style: TextStyle(
                                          color: Colors.white,fontStyle: FontStyle.normal)
                                        ),)
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  )
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Latest Recipes",style: TextStyle(
                    fontFamily: 'PlayfairDisplay',fontSize: 20
                ),),
              ),
              Container(
                child: isLoading
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      recipeList[index].imgUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.lightGreen.shade100),
                                          child:
                                              Text(recipeList[index].label))),
                                  Positioned(
                                    height: 40,
                                    width: 85,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),

                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.local_fire_department,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            Text(recipeList[index]
                                                .calories
                                                .toString()
                                                .substring(0, 6),style: TextStyle(
                                              color: Colors.white
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
