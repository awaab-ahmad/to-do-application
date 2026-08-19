import 'package:flutter/material.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class EmptyCategoryBox extends StatelessWidget {
  const EmptyCategoryBox({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: .symmetric(vertical: 20),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: c.onSecondary,
        borderRadius: .circular(20),
        border: BoxBorder.all(color: c.onPrimaryFixed),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: const .all(10),
            decoration: BoxDecoration(
              color: c.primaryContainer,
              borderRadius: .circular(10),
            ),
            child: Image.asset('assets/images/add_list.png'),
          ),
          const SizedBox(height: 10),
          const Text('No categories yet', style: Style.blc14),
          const SizedBox(height: 5),
          const Text(
            textAlign: .center,
            'Group your tasks by creating your \nfirst category, like Work or Personal.',
            style: Style.gry10,
          ),
          const SizedBox(height: 10),
          ElevatedButton(            
            style: ElevatedButton.styleFrom(
              padding: const .symmetric(vertical: 5),
              backgroundColor: c.primary,
              fixedSize: Size(200, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: .circular(15))
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.add, color: c.secondary, size: 25),
                const SizedBox(width: 5),
                const Text('Create category', style: Style.blc13),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
