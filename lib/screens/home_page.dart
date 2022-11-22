import 'package:flutter/material.dart';
import 'package:news_app_day_37/custom/const.dart';
import 'package:news_app_day_37/custom/custom_http.dart';
import 'package:news_app_day_37/model/news_model.dart';
import 'package:news_app_day_37/screens/search_page.dart';
import 'dart:math';

import 'package:page_transition/page_transition.dart';

const List<String> list = <String>['popularity', 'relevancy', 'publishedAt'];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int pageNo = 1;
  String sortBy = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu), color: Colors.blueGrey,),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: SearchPage(),
                  inheritTheme: true,
                  ctx: context),
            );
          }, icon: Icon(Icons.search), color: Colors.blueGrey,),
        ],
        title: Text("News App", style: myStyle(25, Colors.blueGrey, FontWeight.w700),),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                //color: Colors.red,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          if(pageNo < 1){
                            return;
                          }else{
                            pageNo = pageNo - 1;
                          }
                          setState(() {

                          });
                        },
                        child: Text("Previous", style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(primary: Colors.grey)),
                    SizedBox(width: 5,),
                    Flexible(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                            itemBuilder: (context, index){
                            return Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    pageNo = index+1;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index+1 == pageNo? Colors.grey : Colors.transparent,
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text("${index+1}", style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            );
                            }
                        )),
                    ElevatedButton(onPressed: (){
                      if(pageNo > 1 ){
                        setState(() {
                          pageNo = pageNo + 1;
                        });
                      }
                    }, child: Text("Next", style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(primary: Colors.grey)),
                  ],
                ),
              ),

              SizedBox(height: 15,),
              
              Card(
                child: Row(
                  children: [
                    Text("   Sort By", style: myStyle(20, Colors.blueGrey, FontWeight.w700),),
                    Spacer(),
                    Container(
                      //padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      width: 150,
                      color: Colors.white,
                      child: DropdownButton<String>(
                        value: sortBy,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: myStyle(20, Colors.blueGrey, FontWeight.w500),
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            sortBy = value!;
                          });
                        },
                        items: list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              FutureBuilder<List<Articles>>(
                  future: CustomHttp().fetchAllNewsData(pageNo: pageNo.toString(), sortBy: sortBy),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else if(snapshot.hasError){
                      return Text("Something Error");
                    }
                    else if(snapshot.data == null){
                      return Text("No data found");
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return Card(
                            child: ListTile(
                              leading: Image.network("${snapshot.data![index].urlToImage}"),
                              title: Text("${snapshot.data![index].title}", textAlign: TextAlign.justify,),
                              subtitle: Text("${snapshot.data![index].description}", textAlign: TextAlign.justify,),
                            ),
                          );
                        },
                        separatorBuilder: (context, index)=> SizedBox(height: 15,),
                        itemCount: snapshot.data!.length);
                  }
              ),


            ],
          ),
        ),
      ),
    );
  }
}