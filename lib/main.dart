import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homescreen(),
    );
  }
}

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    const apiKey = "05a278b07e61445d91c5e049773a3f51";
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        articles = (jsonData['articles'] as List)
            .map((data) => Article.fromJson(data))
            .toList();
      });
    } else {
      throw Exception("Failed to get Articles");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade400,
        title: Text(
          "News App",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final articals = articles[index];
              return ListTile(
                title: Text(
                  articals.title,
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                subtitle: Text(
                  "Author : " + articals.author,
                  style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Detailscreen(article: articals)));
                },
              );
            }),
      ),
    );
  }
}

class Article {
  final String title;
  final String author;
  final String description;

  Article({
    required this.title,
    required this.author,
    required this.description,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        title: json["title"] ?? "",
        author: json["author"] ?? "",
        description: json["description"] ?? "");
  }
}

class Detailscreen extends StatelessWidget {
  final Article article;
  const Detailscreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Artical Details",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(
              "author : " + article.author,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              article.description,
              style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
