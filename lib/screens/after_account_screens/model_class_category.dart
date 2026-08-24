import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/state/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/after_acc_topbar.dart';
import 'package:to_do_app/utils/reusables.dart/tasks_related.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

// ignore: must_be_immutable
class ModelCategoryClass extends StatefulWidget {
  String appBarTitle;
  ModelCategoryClass({
    super.key,
    required this.appBarTitle,
  });

  @override
  State<ModelCategoryClass> createState() => _ModelClassState();
}

class _ModelClassState extends State<ModelCategoryClass> {
  @override
  void initState() {
    super.initState();
    final p = context.read<StateManagementProvider>();
    p.resetCatePgBtnInd();
    p.givingStreamOfCategoryPage(widget.appBarTitle, 'Pending');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            children: [
              AfterAccTopBar(
                title: widget.appBarTitle,
                subTitle: 'Read-only tasks',
                extra: () {},
              ),
              const SizedBox(height: 5),
              _PenComBtn(appBarTitle: widget.appBarTitle),
              Selector<StateManagementProvider, Stream>(
                selector: (_, pro) => pro.myCategoriesSteam!,
                builder: (context, strm, child) =>
                    Tasks(appBarTitle: widget.appBarTitle, st: strm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PenComBtn extends StatefulWidget {
  final String appBarTitle;
  const _PenComBtn({required this.appBarTitle});

  @override
  State<_PenComBtn> createState() => _PenComBtnState();
}

class _PenComBtnState extends State<_PenComBtn> {
  static const List<String> btns = ['Pending', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    return SizedBox(
      height: sz.height * 0.06,
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: btns.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const .symmetric(horizontal: 5),
            child: Selector<StateManagementProvider, int>(
              selector: (_, pro) => pro.categoryPgBtnInd,
              builder: (context, ind, child) {
                final selected = ind == index;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    fixedSize: Size(sz.width * 0.43, 0),
                    backgroundColor: selected ? c.secondary : c.onSecondary,
                    side: BorderSide(
                      color: selected ? c.secondary : c.onPrimaryFixed,
                    ),
                  ),
                  onPressed: () {
                    final p = context.read<StateManagementProvider>();
                    p.catePgBtnIndChg(index);
                    context
                        .read<StateManagementProvider>()
                        .givingStreamOfCategoryPage(
                          widget.appBarTitle,
                          btns[index],
                        );
                  },
                  child: Text(
                    btns[index],
                    style: selected ? Style.wht14 : Style.blc14,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
