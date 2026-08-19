import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class AfterAccTopBar extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function extra;
  const AfterAccTopBar({
    super.key,
    required this.title,
    required this.subTitle,
    required this.extra,
  });

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
                extra();
                Navigator.pop(context);
              });
            },
            icon: Icon(Icons.arrow_back_ios_new, color: c.onSecondary),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(title, style: Style.blc18.copyWith(height: 1.1)),
            Text(subTitle, style: Style.gry12),
          ],
        ),
        const Expanded(child: SizedBox()),
        Selector<StateManagementProvider, bool>(
          selector: (_, pro) => pro.isSettingTask,
          builder: (_, toShow, _) {
            if (toShow) {
              return SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: CircularProgressIndicator(
                    color: c.secondary,
                    strokeWidth: 6,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
