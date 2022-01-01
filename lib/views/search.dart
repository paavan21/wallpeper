import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpeper/data/data.dart';
import 'package:wallpeper/model/wallpaper_model.dart';
import 'package:wallpeper/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget{
  final String searchQuery;
  Search({this.searchQuery});
  @override
  _SearchState createState() => _SearchState();

}
class _SearchState extends State<Search> {
  List<PhotosModel> photos = new List();
  TextEditingController searchController = new TextEditingController();

  getSearchWallpaper(String searchQuery) async {
    await http.get(
        "https://api.pexels.com/v1/search?query=$searchQuery&per_page=30&page=1",
        headers: {"Authorization": apiKEY}).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });

      setState(() {});
    });
  }

    @override
    void initState() {
      getSearchWallpaper(widget.searchQuery);
      super.initState();
      searchController.text = widget.searchQuery;
    }


    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
        appBar: AppBar(
          title: brandName(),
          elevation: 0.0,

        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "Search Wallpaper",
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getSearchWallpaper(searchController.text);
                        },
                        child: Container(
                            child: Icon(Icons.search)),
                      )
                    ],),
                  ),
                  SizedBox(height: 16,),
                  wallpaperList(photos, context)
                ]
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
