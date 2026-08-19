import 'package:flutter/material.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class BeforeAccTopBar extends StatelessWidget {
  const BeforeAccTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: c.onPrimary,
            borderRadius: .circular(12),
          ),
          child: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
            },
            icon: Icon(Icons.arrow_back_ios_new, color: c.onSecondary),
          ),
        ),
        const SizedBox(width: 15),
        Text('Doable', style: Style.blc18),
      ],
    );
  }
}
