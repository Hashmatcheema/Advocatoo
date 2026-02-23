import 'package:flutter/material.dart';

/// FAQs screen: accordion-style expandable Q&A (Increment 6).
class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  static const List<({String q, String a})> _faqs = [
    (q: 'How do I add a new case?', a: 'Tap the + button on the Home screen (bottom right). Fill in the case details. Only the case title is required. Tap Save when done.'),
    (q: 'Can I have more than one hearing per case per day?', a: 'No. Advocato allows only one hearing per case per calendar day. If you need to record multiple events on the same day, you can add them in the hearing notes.'),
    (q: 'Where are my documents stored?', a: 'Documents (photos) are stored on your device in app storage. Each case can have multiple folders. You can export a folder as PDF from the folder menu.'),
    (q: 'How do daily reminders work?', a: 'If notifications are enabled in Settings, you will receive a daily reminder at 07:00 (Mon–Sat) with a summary of hearings in the next 7 days. You can turn this off in Settings.'),
    (q: 'Is my data backed up?', a: 'In v1.0, all data is stored only on your device. Data backup and restore are planned for a future update.'),
    (q: 'How do I change the court for a case?', a: 'Open the case, tap Edit (or the edit icon), and select a different court from the Court dropdown. You can add new courts from the Courts Manager in the Menu.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              title: Text(
                faq.q,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    faq.a,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
