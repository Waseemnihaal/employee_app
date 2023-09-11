import 'package:flutter/material.dart';

class Utils {
  ///
  Future<void> showAppSnackBar(BuildContext context, String action,
      String description, VoidCallback onTapAction) async {
    SnackBar snackbar = SnackBar(
      content: Text(description),
      action: SnackBarAction(
        label: action,
        onPressed: onTapAction,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
