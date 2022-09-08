// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/fullscreen.dart';


class Wallpaper extends StatefulWidget {
  const Wallpaper({Key? key}) : super(key: key);

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          'Authorization':
              '563492ad6f9170000100000189c8255155f541388cd6a86c4a571c99'
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[1]);
    });
  }

  Loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f9170000100000189c8255155f541388cd6a86c4a571c99'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Wallpapers'),),
      body: Column(
        children: [
          Expanded(
              child: Container(
            child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreen(
                            imageurl: images[index]['src']['large2x'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Image.network(
                        images[index]['src']['tiny'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          )),
          SizedBox(height: 5,),
          InkWell(
            onTap: () {
              Loadmore();
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
              height: 40,
              width: 140,
              //color: Colors.blue,
              child: Center(
                child: Text(
                  'Load More',
                  style: TextStyle(fontSize: 20, color: Colors.white,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
