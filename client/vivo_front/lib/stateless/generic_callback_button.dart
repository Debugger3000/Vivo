import 'package:flutter/material.dart';


// Button to use when logic needs to be local to parents state
// Callback button, so onPressed will trigger function in parent
// ----------
class GenericCallBackButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const GenericCallBackButton({
    super.key,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed, // invoke callback function passed to this child widget
      child: Text(name),
    );
  }
}

// Parent creates the GlobalKey pointing to the child's State
  // final GlobalKey<_ChildWidgetState> _childKey = GlobalKey<_ChildWidgetState>();

  // Parent calls a method in the child directly
            // _childKey.currentState?.doSomething();


