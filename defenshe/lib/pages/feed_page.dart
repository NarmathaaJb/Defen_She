import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as htmlParser;


class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

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
  const feedUrl = 'https://rss.app/feeds/tR2NXyyw6ucbhOmd.xml'; // Example feed
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
  if (url.isNotEmpty && Uri.tryParse(url)?.isAbsolute == true) {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch: $url');
    }
  } else {
    print('Invalid URL: $url');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF06292),
        title: const Text('Women News Feed', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : articles.isEmpty
              ? const Center(child: Text('No news found.'))
              : ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              article['description'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _launchURL(article['link'] ?? ''),
                                icon: const Icon(Icons.open_in_new, size: 18, color: Colors.pink,),
                                label: const Text("Read More", style: TextStyle(color: Colors.pink),),
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
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
