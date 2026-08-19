import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/field_borders.dart';
import 'package:to_do_app/utils/global_items.dart';
import 'package:to_do_app/utils/reusables.dart/before_acc_topbar.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

// ignore: must_be_immutable
class ResetPassPage extends StatelessWidget {
  TextEditingController resetPassController = TextEditingController();
  ResetPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const .symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: .center,
              children: [
                const BeforeAccTopBar(),
                const SizedBox(height: 30),
                const _MailIcon(),
                const SizedBox(height: 15),
                const Text('Forgot password?', style: Style.blc17Light),
                const SizedBox(height: 5),
                const Text(
                  textAlign: .center,
                  'No worries — enter the email linked \nto your account and we\'ll send \nyou a reset link.',
                  style: Style.gry12,
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: .centerLeft,
                  child: const Text('Email', style: Style.gry14),
                ),
                const SizedBox(height: 5),
                _MailField(tc: resetPassController),
                const SizedBox(height: 15),
                _LinkButton(tc: resetPassController),
                const Expanded(child: SizedBox()),
                const _LastLine(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MailIcon extends StatelessWidget {
  const _MailIcon();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(shape: .circle, color: c.onSecondary),
      child: Icon(Icons.mail_lock, size: 45, color: c.onSecondaryFixed),
    );
  }
}

class _MailField extends StatelessWidget {
  final TextEditingController tc;
  const _MailField({required this.tc});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return TextField(
      controller: tc,
      style: Style.gry13,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 02,
          horizontal: 08,
        ),
        prefixIcon: Icon(
          Icons.mail_outline,
          color: c.onSurfaceVariant,
          size: 25,
        ),
        hintText: 'user@gmail.com',
        hintStyle: Style.mutedGry13,
        focusedBorder: focusB,
        enabledBorder: enabledB,
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final TextEditingController tc;
  const _LinkButton({required this.tc});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: () async {
        final p = context.read<StateManagementProvider>();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Center(child: const GlobalIndicator()),
        );
        await p.resettingPasswordFunction(tc);
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: c.primary,
        shape: RoundedRectangleBorder(borderRadius: .circular(10)),
        fixedSize: Size(double.maxFinite, 50),
      ),
      child: Text('Send reset link', style: Style.blc17Light),
    );
  }
}

class _LastLine extends StatelessWidget {
  const _LastLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        const Text('Remember your password?', style: Style.gry12),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text('Log in', style: Style.grn12),
        ),
      ],
    );
  }
}
