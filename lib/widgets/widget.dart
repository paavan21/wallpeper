import 'package:flutter/material.dart';
import 'package:wallpeper/model/wallpaper_model.dart';
import 'package:wallpeper/views/image_view.dart';

Widget brandName(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wallpaper",
        style: TextStyle(color: Colors.black87, fontFamily: 'Overpass'),
      ),
      Text(
        "Drive",
        style: TextStyle(color: Colors.red, fontFamily: 'Overpass'),
      )
    ],
  );
}

Widget wallpaperList(List<PhotosModel> listPhotos, BuildContext context,  ){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        crossAxisCount: 2,
      childAspectRatio: 0.6,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: listPhotos.map((PhotosModel photosModel){
        return GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ImageView(
                  imgUrl: photosModel.src.portrait,
                )
              ));
            },
            child: Hero(
              tag: photosModel.src.portrait,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                    child: Image.network(photosModel.src.portrait, fit: BoxFit.cover)),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}