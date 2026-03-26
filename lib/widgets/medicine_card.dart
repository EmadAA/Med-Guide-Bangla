import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final Map<String, dynamic> medicine;

  final String nameQuery;
  final String symptomQuery;
  final String actionQuery;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.nameQuery,
    required this.symptomQuery,
    required this.actionQuery,
  });

  Widget highlightText(String text, String query, Color color) {
    if (query.trim().isEmpty) {
      return Text(text, style: const TextStyle(color: Colors.black));
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(text, style: const TextStyle(color: Colors.black));
    }

    final start = lowerText.indexOf(lowerQuery);
    final end = start + query.length;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black), // 🔥 FIX white text
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(end)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symptoms = medicine['লক্ষণ'] ?? [];
    final actions = medicine['কার্যকারিতা'] ?? [];
    final cure = medicine['উপসম'] ?? [];

    return SizedBox(
      width: double.infinity, // ✅ FIX WIDTH
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              highlightText(
                "${medicine['medicine_name_en']} (${medicine['ওষুধের নাম']})",
                nameQuery,
                Colors.orange,
              ),

              const SizedBox(height: 10),

              if (symptoms.isNotEmpty) ...[
                const Text(
                  "লক্ষণ:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...symptoms.map<Widget>(
                  (s) => highlightText("• $s", symptomQuery, Colors.blue),
                ),
              ],

              const SizedBox(height: 10),

              if (actions.isNotEmpty) ...[
                const Text(
                  "কার্যকারিতা:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...actions.map<Widget>(
                  (a) => highlightText(
                    "• ${a['category']} : ${a['description']}",
                    actionQuery,
                    Colors.green,
                  ),
                ),
              ],

              const SizedBox(height: 10),

              if (cure.isNotEmpty) ...[
                const Text(
                  "উপসম:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...cure.map<Widget>(
                  (c) => highlightText("• $c", actionQuery, Colors.purple),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
