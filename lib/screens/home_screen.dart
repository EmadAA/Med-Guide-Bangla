import 'package:flutter/material.dart';

import '../services/json_service.dart';
import '../widgets/medicine_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> allData = [];
  List<dynamic> filteredData = [];

  final ScrollController _scrollController = ScrollController();

  final nameEnController = TextEditingController();
  final nameBnController = TextEditingController();
  final symptomController = TextEditingController();
  final actionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await JsonService.loadData();
    setState(() {
      allData = data;
    });
  }

  void search() {
    final nameEn = nameEnController.text.trim();
    final nameBn = nameBnController.text.trim();
    final symptom = symptomController.text.trim();
    final action = actionController.text.trim();

    // 🚫 Empty search alert
    if (nameEn.isEmpty && nameBn.isEmpty && symptom.isEmpty && action.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type something to search"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final results = allData.where((item) {
      bool match = true;

      if (nameEn.isNotEmpty) {
        match &= item['medicine_name_en'].toLowerCase().contains(
          nameEn.toLowerCase(),
        );
      }

      if (nameBn.isNotEmpty) {
        match &= item['ওষুধের নাম'].contains(nameBn);
      }

      if (symptom.isNotEmpty) {
        match &= (item['লক্ষণ'] as List).any(
          (s) => s.toString().contains(symptom),
        );
      }

      if (action.isNotEmpty) {
        match &= (item['কার্যকারিতা'] as List).any(
          (a) =>
              a['category'].toString().contains(action) ||
              a['description'].toString().contains(action),
        );
      }

      return match;
    }).toList();

    setState(() {
      filteredData = results;
    });
  }

  void reset() {
    setState(() {
      filteredData.clear();
      nameEnController.clear();
      nameBnController.clear();
      symptomController.clear();
      actionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Med Guide Bangla'),
        backgroundColor: const Color.fromARGB(255, 114, 221, 210),
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/all');
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 TOP ROW
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameEnController,
                      decoration: InputDecoration(
                        labelText: 'Medicine Name',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: nameBnController,
                      decoration: InputDecoration(
                        labelText: 'ওষুধের নাম',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextField(
                controller: symptomController,
                decoration: InputDecoration(
                  labelText: 'লক্ষণ / Symptom',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: actionController,
                decoration: InputDecoration(
                  labelText: 'কার্যকারিতা / Effectiveness',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        search();

                        // 🔥 AUTO SCROLL
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _scrollController.animateTo(
                            300, // 🔥 adjust this value
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Search'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          114,
                          221,
                          210,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: reset,
                      child: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 RESULT COUNT
              if (filteredData.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${filteredData.length} results found",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              // 🔹 EMPTY STATE
              if (filteredData.isEmpty)
                Column(
                  children: const [
                    Icon(Icons.search_off, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No Result Found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

              // 🔹 RESULTS
              ...filteredData.map((item) {
                return MedicineCard(
                  medicine: item,
                  nameQuery: nameEnController.text + nameBnController.text,
                  symptomQuery: symptomController.text,
                  actionQuery: actionController.text,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
