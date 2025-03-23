import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as htmlParser;


class FeedPage extends StatefulWidget {
  @override
  _WomenNewsFeedPageState createState() => _WomenNewsFeedPageState();
}

class _WomenNewsFeedPageState extends State<FeedPage> {
  List<Map<String, String>> articles = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRssFeed();
  }

  Future<void> fetchRssFeed() async {
  final feedUrl = 'https://rss.app/feeds/tR2NXyyw6ucbhOmd.xml'; // Example feed
  try {
    final response = await http.get(Uri.parse(feedUrl));
    final document = xml.XmlDocument.parse(response.body);
    final items = document.findAllElements('item');

    final fetchedArticles = items.map((item) {
      final rawDescription = item.getElement('description')?.text ?? '';
      final parsedDescription = htmlParser.parse(rawDescription).body?.text ?? '';
      return {
        'title': item.getElement('title')?.text ?? '',
        'link': item.getElement('link')?.text ?? '',
        'description': parsedDescription,
      };
    }).toList();

    setState(() {
      articles = fetchedArticles;
      loading = false;
    });
  } catch (e) {
    print('Error fetching RSS: $e');
    setState(() {
      loading = false;
    });
  }
}


  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF06292),
        title: Text('Women News Feed', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : articles.isEmpty
              ? Center(child: Text('No news found.'))
              : ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article['title'] ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              article['description'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _launchURL(article['link'] ?? ''),
                                icon: Icon(Icons.open_in_new, size: 18, color: Colors.pink,),
                                label: Text("Read More", style: TextStyle(color: Colors.pink),),
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
