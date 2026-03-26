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

    // 🚫 Empty search
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
              a['category'].contains(action) ||
              a['description'].contains(action),
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
          FocusScope.of(context).unfocus(); // 🔥 hide keyboard on outside tap
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameEnController,
                      decoration: InputDecoration(
                        labelText: 'Medicine Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: actionController,
                decoration: InputDecoration(
                  labelText: 'কার্যকারিতা / Effectiveness',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        search();
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: reset,
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (filteredData.isEmpty) const Text("No Result Found"),

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
