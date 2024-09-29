import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomSweetAlert extends StatelessWidget {
  final String title;
  final String confirmButtonText;
  final String cancelButtonText;
  final Function() onConfirm;
  final Function() onCancel;
  final IconData icon;

  const CustomSweetAlert({
    super.key,
    required this.title,
    this.confirmButtonText = "",
    this.cancelButtonText = "",
    required this.onConfirm,
    required this.onCancel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: (icon == FontAwesomeIcons.check ? Colors.greenAccent : Colors.red),
            ),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'thaifont')),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cancelButtonText.isNotEmpty)
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red,
                      ),
                      child: TextButton(
                        onPressed: () {
                          onCancel();
                          Navigator.of(context).pop();
                        },
                        child: Text(cancelButtonText, style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
                      ),
                    ),
                  if (confirmButtonText.isNotEmpty && cancelButtonText.isNotEmpty)
                    const SizedBox(
                      width: 20,
                      height: 30,
                    ),
                  if (confirmButtonText.isNotEmpty)
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green,
                      ),
                      child: TextButton(
                        onPressed: () {
                          onConfirm();
                          Navigator.of(context).pop();
                        },
                        child: Text(confirmButtonText, style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
