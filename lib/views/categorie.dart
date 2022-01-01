import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpeper/data/data.dart';
import 'package:wallpeper/model/wallpaper_model.dart';
import 'package:wallpeper/widgets/widget.dart';
class Categories extends StatefulWidget{
  final String categorie;
  // final String categoryName;
  Categories({this.categorie});
  @override
  _CategoriesState createState() => _CategoriesState();
}
class _CategoriesState extends State<Categories>{

  List<PhotosModel> photos = new List();
  TextEditingController searchController = new TextEditingController();

  getCategorieWallpaper() async {
    await http.get(
        "https://api.pexels.com/v1/search?query=${widget.categorie}&per_page=30&page=1",
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
  void initState() {
    getCategorieWallpaper();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,

      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
              children: <Widget>[

                SizedBox(height: 16,),
                wallpaperList(photos, context)
              ]
          ),
        ),
      ),
    );
  }
}