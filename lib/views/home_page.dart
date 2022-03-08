import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../helper/data.dart';
import '../helper/news.dart';
import '../helper/widgets.dart';
import '../models/categorie_model.dart';
import 'article_views.dart';
import 'categorie_news.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _loading = true;

  List<CategorieModel> categories = <CategorieModel>[];

  var newslist = [];

  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      newslist.isEmpty ? _loading = true : _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: _loading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      /// Categories
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 70,
                        // child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: categories.length,
                        //     itemBuilder: (context, index) {
                        //       return CategoryCard(
                        //         imageAssetUrl: categories[index].imageAssetUrl,
                        //         categoryName: categories[index].categorieName,
                        //       );
                        //     }),
                        child: VxSwiper.builder(
                          height: 50.0,
                          viewportFraction: 0.35,
                          autoPlay: true,
                          autoPlayAnimationDuration: 3.seconds,
                          autoPlayCurve: Curves.linear,
                          enableInfiniteScroll: true,
                          itemCount: categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryCard(
                                imageAssetUrl: categories[index].imageAssetUrl,
                                categoryName: categories[index].categorieName
                            );
                          },
                        ),
                      ),

                      /// News Article
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: ListView.builder(
                            itemCount: newslist.length,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return NewsTile(
                                imgUrl: newslist[index].urlToImage ?? "",
                                title: newslist[index].title ?? "",
                                desc: newslist[index].description ?? "",
                                content: newslist[index].content ?? "",
                                posturl: newslist[index].articleUrl ?? "",
                              );
                              //return Container(color: Colors.blue,height: 10,margin: const EdgeInsets.all(10),padding: const EdgeInsets.all(10),);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getNews();
          });
          },
        child: const Icon(Icons.next_plan, color: Colors.white,),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName;

  CategoryCard({required this.imageAssetUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                    newsCategory: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                imageAssetUrl,
                height: 60,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl;

  NewsTile(
      {required this.imgUrl,
      required this.desc,
      required this.title,
      required this.content,
      required this.posturl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      postUrl: posturl,
                )
            )
        );
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      imgUrl,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  desc,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                )
              ],
            ),
          )),
    );
  }
}
