import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/visit_controller.dart';
import '../models/visit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<VisitController>().history;

    if (history.isEmpty) {
      return const Center(
        child: Text(
          'Zatiaľ žiadna história',
          style: TextStyle(fontSize: 20, color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: history.length,
      itemBuilder: (_, i) {
        final Visit v = history[i];

        return Card(
          color: Colors.grey.shade800,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.meno,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${v.auto} • ${v.spz}',
                    style: const TextStyle(fontSize: 18)),
                if (v.zaKym.isNotEmpty)
                  Text('Za kým: ${v.zaKym}',
                      style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  _formatDate(v.time),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime d) {
    return '${_two(d.day)}.${_two(d.month)}.${d.year}  '
        '${_two(d.hour)}:${_two(d.minute)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
