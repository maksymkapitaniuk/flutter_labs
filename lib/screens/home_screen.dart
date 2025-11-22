import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../core/widgets/book_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: Colors.black,
              indicatorWeight: 2,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: "My Reading"),
                Tab(text: "Users Reading"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  MockData.userName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: MockData.myReadingList.length,
                    itemBuilder: (context, index) {
                      return BookListItem(book: MockData.myReadingList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Center(child: Text("Users reading list goes here")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4A7AFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
