import 'package:flutter/material.dart';

import '../services/json_service.dart';
import '../widgets/medicine_card.dart';

class AllMedicineScreen extends StatefulWidget {
  const AllMedicineScreen({super.key});

  @override
  State<AllMedicineScreen> createState() => _AllMedicineScreenState();
}

class _AllMedicineScreenState extends State<AllMedicineScreen> {
  List<dynamic> allData = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Medicines"),
        backgroundColor: const Color.fromARGB(255, 114, 221, 210),
      ),
      body: ListView.builder(
        itemCount: allData.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "${index + 1}.",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              MedicineCard(
                medicine: allData[index],
                nameQuery: "",
                symptomQuery: "",
                actionQuery: "",
              ),
            ],
          );
        },
      ),
    );
  }
}
