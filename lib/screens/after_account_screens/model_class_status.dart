import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/after_acc_topbar.dart';
import 'package:to_do_app/utils/reusables.dart/tasks_related.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

// ignore: must_be_immutable
class ModelStatusClass extends StatefulWidget {
  final String appBarTitle;
  const ModelStatusClass({super.key, required this.appBarTitle});

  @override
  State<ModelStatusClass> createState() => _ModelClassState();
}

class _ModelClassState extends State<ModelStatusClass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        context.read<StateManagementProvider>().cancelMultipleAllow();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: SafeArea(
            child: Column(
              children: [
                _TopBar(appBarTitle: widget.appBarTitle),
                const SizedBox(height: 5),
                Tasks(
                  appBarTitle: widget.appBarTitle,
                  st: context.read<StateManagementProvider>().taskStreamFetch(
                    widget.appBarTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String appBarTitle;
  const _TopBar({required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final isPen = appBarTitle == 'Pending';
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.toSelectMultiple,
      builder: (context, allowed, child) {
        if (allowed) {
          return _MoreOptionsBox(appBarTitle: appBarTitle);
        }
        return Selector<StateManagementProvider, int>(
          selector: (_, pro) => isPen ? pro.pendingTasks : pro.completedTasks,
          builder: (_, length, _) => AfterAccTopBar(
            title: appBarTitle,
            subTitle: appBarTitle != 'Deleted'
                ? '$length Tasks'
                : 'Manage Recently deleted',
            extra: () {},
          ),
        );
      },
    );
  }
}

class _MoreOptionsBox extends StatelessWidget {
  final String appBarTitle;
  const _MoreOptionsBox({required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: c.secondary,
        borderRadius: .circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                padding: .zero,
                onPressed: () {
                  context.read<StateManagementProvider>().cancelMultipleAllow();
                },
                icon: Icon(Icons.close_rounded, color: c.onSecondary, size: 30),
              ),
              const SizedBox(width: 0),
              Selector<StateManagementProvider, int>(
                selector: (_, pro) => pro.toSelectMList.length,
                builder: (_, len, _) =>
                    Text('$len Selected', style: Style.wht14),
              ),
              const Expanded(child: SizedBox()),
              Selector<StateManagementProvider, bool>(
                selector: (_, pro) => pro.isSettingTask,
                builder: (_, toShow, _) {
                  if (toShow) {
                    return SizedBox(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: c.onSecondary,
                          strokeWidth: 5,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          appBarTitle != 'Deleted'
              ? Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final p = context.read<StateManagementProvider>();
                        await p.movingMultipleTasks(
                          appBarTitle == 'Pending' ? 'Completed' : 'Pending',
                        );
                        await p.pendingCompletedLengthGetting();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const .symmetric(horizontal: 18),
                        backgroundColor: c.tertiary,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: c.onSecondary,
                            size: 25,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appBarTitle == 'Pending'
                                ? 'Mark as completed'
                                : 'Mark as pending',
                            style: Style.wht12,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final p = context.read<StateManagementProvider>();
                        await p.movingMultipleTasks('Deleted');
                        await p.pendingCompletedLengthGetting();
                      },
                      child: Icon(Icons.delete, color: c.error, size: 30),
                    ),
                  ],
                )
              : const _DeleteRow(),
        ],
      ),
    );
  }
}

class _DeleteRow extends StatelessWidget {
  const _DeleteRow();

  static ButtonStyle stl(Color bg) {
    return ElevatedButton.styleFrom(
      padding: const .symmetric(horizontal: 18),
      backgroundColor: bg,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final p = context.read<StateManagementProvider>();
              await p.movingMultipleTasks('Pending');
              await p.pendingCompletedLengthGetting();
            },
            style: stl(c.primary),
            child: Text('Pending', style: Style.blc11),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final p = context.read<StateManagementProvider>();
              await p.movingMultipleTasks('Completed');
              await p.pendingCompletedLengthGetting();
            },
            style: stl(c.tertiary),
            child: Text('Completed', style: Style.wht12),
          ),
        ),
        const SizedBox(width: 5),
        IconButton(
          onPressed: () async {
            final p = context.read<StateManagementProvider>();
            await p.deletingMultipleTasks();
          },
          icon: Icon(Icons.delete, color: c.error, size: 30),
        ),
      ],
    );
  }
}
