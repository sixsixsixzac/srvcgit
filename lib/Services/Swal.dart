import 'package:flutter/material.dart';

import 'package:srvc/Widgets/Swal.dart';

void showCustomAlert(BuildContext context, title, confirmbtn, cancelbtn, icon, onConfirm, onCancel) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomSweetAlert(
        title: title,
        confirmButtonText: confirmbtn,
        cancelButtonText: cancelbtn,
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon,
      );
    },
  );
}
