import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String? errorMessage;
  const ErrorText({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorMessage!));
  }
}
