import 'package:flutter/material.dart';
import 'package:task_app/widgets/rounded_icon_button.dart';

class ShadowedCard extends StatelessWidget {
  final String title;
  final String description;
  final bool cbState;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final ValueChanged<bool?> onCBPressed;

  const ShadowedCard({
    super.key, 
    required this.title,
    required this.description,
    required this.cbState,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onCBPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          checkColor: Colors.white,
          value: cbState,
          fillColor: MaterialStateProperty.resolveWith((states) => Colors.blueAccent),
          onChanged: onCBPressed,
        ),
        
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              decoration: cbState? TextDecoration.lineThrough : null,
              color: cbState? Colors.blueGrey : null,
            ),
          ),
        ),
        
        subtitle: Text(
          description,
          style: TextStyle(
            color: cbState? Colors.blueGrey : null,
          ),
        ),

        // -------------------- BUTTONS --------------------
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     // RoundedIconButton(
        //     //   icon: Icons.edit,
        //     //   color: Colors.indigoAccent,
        //     //   onPressed: onEditPressed,
        //     // ),
        //     RoundedIconButton(
        //       icon: Icons.delete,
        //       color: Colors.redAccent,
        //       onPressed: onDeletePressed,
        //     ),
        //   ],
        // ),
        trailing: RoundedIconButton(
          icon: Icons.delete,
          color: Colors.redAccent,
          onPressed: onDeletePressed,
        ),
        onTap: () {
          onEditPressed();
        },
      ),
    );
  }
}
