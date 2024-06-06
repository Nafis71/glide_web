import 'package:flutter/material.dart';
import 'package:glide_web/viewModels/web_view_model.dart';

class MicAlertDialog extends StatelessWidget {
  final Widget titleTextWidget, contentTextWidget, micIconWidget;
  final Function micOnPressed;
  final WebViewModel webViewModel;

  const MicAlertDialog(
      {super.key,
      required this.titleTextWidget,
      required this.contentTextWidget,
      required this.micOnPressed,
      required this.webViewModel,
      required this.micIconWidget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleTextWidget,
      content: SizedBox(
        height: 100,
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                micOnPressed();
              },
              icon: micIconWidget,
            ),
            contentTextWidget,
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              webViewModel.loadVoiceUrl();
              Navigator.pop(context);
            },
            child: const Text("Search"))
      ],
    );
  }
}
