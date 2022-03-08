import 'package:http/http.dart' as http;

import 'dart:convert';


import '../models/article.dart';


import '../secret.dart';



class News {

  List<Article> news  = [];

  Future<void> getNews() async{

    String url = "http://newsapi.org/v2/top-headlines?country=in&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=$apiKey";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == "ok"){
      jsonData["articles"].forEach((element){

        if(element['urlToImage'] != null && element['description'] != null){
          Article article = Article(
            title: element['title'],
            //author: element['author'],
            author: "Auteur",
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            //content: element["content"],
            content: "Contenu",
            articleUrl: element["url"],
          );
          news.add(article);
        }

      });
    }


  }


}

class NewsForCategorie {

  List<Article> news = [];

  Future<void> getNewsForCategory(String category) async {

    String url = "https://newsapi.org/v2/top-headlines?country=fr&category=$category&apiKey=$apiKey";


    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element['title'],
            //author: element['author'],
            author: "AUteur",
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}