import 'package:flutter/material.dart';

class LoaderOrError extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final Widget Function(dynamic data) child;

  const LoaderOrError({required this.snapshot, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return child(snapshot.data);
    }
  }
}
