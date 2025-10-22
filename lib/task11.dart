import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';

class Task11 extends StatefulWidget {
  const Task11({super.key});

  @override
  State<Task11> createState() => _Task11State();
}

class _Task11State extends State<Task11> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  List<dynamic> currencies = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchRates() async {
    final date = dateController.text.trim();
    final code = codeController.text.trim().toUpperCase();

    String url = 'https://cbu.uz/ru/arkhiv-kursov-valyut/json/';
    if (code.isNotEmpty && code != 'ALL') {
      if (date.isNotEmpty) {
        url = 'https://cbu.uz/ru/arkhiv-kursov-valyut/json/$code/$date/';
      } else {
        url = 'https://cbu.uz/ru/arkhiv-kursov-valyut/json/$code/';
      }
    } else if (date.isNotEmpty) {
      url = 'https://cbu.uz/ru/arkhiv-kursov-valyut/json/all/$date/';
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      currencies = [];
    });

    try {
      final response = await HttpRequest.getString(url);
      final data = jsonDecode(response);

      // The API returns either a List or a single object
      final result = data is List ? data : [data];

      setState(() {
        currencies = result;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        errorMessage =
            'Failed to fetch rates. Please check input or try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
          child:
              Text(errorMessage!, style: const TextStyle(color: Colors.red)));
    }

    if (currencies.isEmpty) {
      return const Center(child: Text('No data loaded.'));
    }

    return ListView.builder(
      itemCount: currencies.length,
      itemBuilder: (context, index) {
        final item = currencies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text('${item['CcyNm_UZ'] ?? item['CcyNm_RU']}'),
            subtitle: Text('Code: ${item['Ccy']} — Rate: ${item['Rate']} UZS'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 11 — Currency Rates (CBU.uz)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fetch Currency Rates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Currency Code (USD, RUB, or all)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchRates,
              child: const Text('Fetch Rates'),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }
}
