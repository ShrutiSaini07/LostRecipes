import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lost_recipes/model.dart';



// ignore: must_be_immutable
class Search extends StatefulWidget {
  String query;
  Search(this.query);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchCtrl = new TextEditingController();
  List reciptCatList = [{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chilli Food"}];
  getRecipes(String query) async {
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
      print(Recipe.calories);
    });
  }
  @override
  void initState() {
    super.initState();
    getRecipes(widget.query);
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
              gradient: LinearGradient(
                  colors: [Color(0xff213A50), Color(0xff071938)]),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                //Search Bar
                SafeArea(
                  child: Container(
                    //Search Wala Container

                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchCtrl.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Search(searchCtrl.text)));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,

                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something!"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                    child: isLoading ? CircularProgressIndicator() : ListView.builder(
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
                                      )),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black26),
                                          child: Text(
                                            recipeList[index].label,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ))),
                                  Positioned(
                                    right: 0,
                                    height: 40,
                                    width: 80,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10)
                                            )
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.local_fire_department, size: 15,),
                                              Text(recipeList[index].calories.toString().substring(0, 6)),
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          );
                        })),






              ],
            ),
          ),


        ],
      ),
    );
  }
}
