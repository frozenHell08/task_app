import 'package:flutter/material.dart';
import 'package:task_app/widgets/rounded_icon_button.dart';

class ShadowedCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ShadowedCard({
    super.key, 
    required this.title,
    required this.description,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 2,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        subtitle: Text(description),

        // -------------------- BUTTONS --------------------
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedIconButton(
              icon: Icons.edit,
              color: Colors.indigoAccent,
              onPressed: onEditPressed,
            ),
            RoundedIconButton(
              icon: Icons.delete,
              color: Colors.redAccent,
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}
