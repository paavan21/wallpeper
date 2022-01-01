import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpeper/data/data.dart';
import 'package:wallpeper/model/categories_model.dart';
import 'package:wallpeper/model/wallpaper_model.dart';
import 'package:wallpeper/views/categorie.dart';
import 'package:wallpeper/views/image_view.dart';
import 'package:wallpeper/views/search.dart';

import 'package:wallpeper/widgets/widget.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}
class _HomeState extends State<Home> {
  List<CategorieModel> categories = new List();
  List<PhotosModel> photos = new List();
  int noOfImageToLoad = 100;
  ScrollController _scrollController = new ScrollController();

  TextEditingController searchController = new TextEditingController();

  getTrendingWallpaper() async {
    await http.get(
        "https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad",
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
  void initState(){

    categories = getCategories();
    super.initState();
    getTrendingWallpaper();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        noOfImageToLoad = noOfImageToLoad + 30;
        getTrendingWallpaper();
      }
    });
  }

  // _launchURL(String url)async{
  //   if(await canLaunch(url)){
  //     await launch(url);
  //   }else{
  //     throw 'Could not lounch $url';
  //   }
  // }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
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
              child: Row(
                children: <Widget>[
              Expanded(
                child:TextField(
                  controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search Wallpaper",
                  border: InputBorder.none
                ),
              ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Search(
                      searchQuery: searchController.text,
                    )
                  ));
                },
                child: Container(
                  child: Icon(Icons.search)),
              )
            ],),
            ),

            SizedBox(height: 16,),
            Container(
              height: 80,
              child:ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder:(context,index){
                    return CategoriesTile(
                      title: categories[index].categorieName,
                      imgUrl: categories[index].imgUrl,
                    );
                  })
            ),
            wallpaperList(photos,context)
          ],
        ),),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget{
  final String imgUrl,title;
  CategoriesTile({@required this.title,@required this.imgUrl});
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Categories(
            categorie: title.toLowerCase(),
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(children: <Widget>[
          GestureDetector(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(
               builder: (context) => ImageView()
             ));
            },
            child: Hero(
              tag: imgUrl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:Image.network(imgUrl,height: 50, width: 100,fit: BoxFit.cover,),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black26,
              borderRadius: BorderRadius.circular(8)
            ),
            height: 50, width: 100,
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),),
          ),
        ],)
      ),
    );
}
}