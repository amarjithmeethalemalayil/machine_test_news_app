import 'package:flutter/material.dart';
import '../widgets/common_appbar.dart';
import '../widgets/news_box.dart';
import '../widgets/search_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 20.0)..copyWith(bottom: 0.0),
          child: Column(
            children: [
              SearchBox(controller: _searchController,
                onSubmitted: (demo){},
              ),
              NewsBox(
                imageUrl: "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png",
                title: "title",
                publishedAt: "publishedAt",
                obj: "obj",
              ),
            ],
          ),
        )
      ),
    );
  }
}
