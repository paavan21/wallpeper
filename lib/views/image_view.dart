
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget{
  final String imgUrl;

  ImageView({@required this.imgUrl});
  @override
  _ImageViewState createState() => _ImageViewState();




  
}
class _ImageViewState extends State<ImageView>{
  var imgPath;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:kIsWeb
                  ? Image.network(widget.imgUrl,fit: BoxFit.cover,)
            :CachedNetworkImage(
                imageUrl: widget.imgUrl,
                placeholder: (context, url) => Container(
                  color: Color(0xfff5f8fd),
                ),
                fit: BoxFit.cover,
              )),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children:<Widget>[
            InkWell(
              onTap: (){
                _save();

              },
              child: Stack(
                children: <Widget>[  
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    color: Color(0xff1c1B1B).withOpacity(0.8),)
                  ),
                  Container(
                    height: 50,
                  width: MediaQuery.of(context).size.width/2,
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54,width: 1),
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF)
                          ],
                        begin: FractionalOffset.topLeft,
                        end:FractionalOffset.bottomRight
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Download Wallpaper",style: TextStyle(
                          fontSize: 16,color: Colors.white70),),
                      Text("Image Will be saved in gallery",style: TextStyle(fontSize: 10, color: Colors.white70),)
                    ],
                  ),
                ),],
              ),
            ),

                SizedBox(height: 16,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: Text("Back", style: TextStyle(color: Colors.white60 ),)),
            ],),
            
          )
        ],
      ),
    );
  }
  _save() async {

    await _askPermission();
    var response = await Dio().get(widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */await PermissionHandler()
          .requestPermissions([PermissionGroup.photos]);
    } else {
      /* PermissionStatus permission = */await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}