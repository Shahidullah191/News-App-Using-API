import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news_app_day_37/custom/const.dart';
import 'package:news_app_day_37/custom/custom_http.dart';
import 'package:news_app_day_37/model/news_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<Articles> searchData = [];
  List<String> searchKeyWord = [
    "Football",
    "World",
    "Tramp",
    "cricket",
    "Sports",
    "Politics",
    "Tesla",
    "Biden"
  ];

  FocusNode? focusNode = FocusNode();
  bool isSearch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          "Search News",
          style: myStyle(25, Colors.blueGrey, FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blueGrey),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: 100,
                child: TextField(
                  focusNode: focusNode,
                  controller: searchController,
                  onEditingComplete: () async {
                    searchData = await CustomHttp().fetchSearchNewsData(
                        pageNo: 1.toString(),
                        query: searchController.text.toString());
                    isSearch = false;
                    setState(() {});
                    focusNode!.nextFocus();
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            searchData = [];
                            focusNode!.unfocus();
                            isSearch = true;

                            setState(() {});
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ))),
                ),
              ),
            ),

            /*  TextField(
              focusNode: focusNode,
              controller: searchController,
              onChanged: (value) async {
                searchData = await CustomHttp().fetchSearchNewsData(
                    pageNo: 1, query: searchController.text.toString());
                isSearch = true;
                setState(() {});
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        searchData = [];
                        focusNode!.unfocus();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ))),
            ),*/

            isSearch == true
                ? Container(
                    height: 120,
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.count(
                      itemCount: searchKeyWord.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            searchData = await CustomHttp().fetchSearchNewsData(
                                pageNo: 1.toString(),
                                query: "${searchKeyWord[index]}");
                            setState(() {});
                          },
                          child: Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: FittedBox(
                                        child:
                                            Text("${searchKeyWord[index]}"))),
                              )),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            searchData.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.separated(
                      separatorBuilder: (context, index)=> SizedBox(height: 15,),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: searchData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading:
                                Image.network("${searchData[index].urlToImage}"),
                            title: Text("${searchData[index].title}", textAlign: TextAlign.justify,),
                            subtitle: Text("${searchData[index].description}", textAlign: TextAlign.justify,),
                          ),
                        );
                      }),
                )
                : SizedBox(height: 0,)
          ],
        ),
      ),
    );
  }
}
