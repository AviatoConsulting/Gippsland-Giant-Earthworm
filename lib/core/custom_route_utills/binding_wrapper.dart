import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class BindingWrapper extends StatefulWidget {
  final Bindings? binding;
  final Widget Function(BuildContext, GoRouterState) pageBuilder;
  final GoRouterState state;

  const BindingWrapper({
    super.key,
    this.binding,
    required this.pageBuilder,
    required this.state,
  });

  @override
  _BindingWrapperState createState() => _BindingWrapperState();
}

class _BindingWrapperState extends State<BindingWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize bindings if provided
    widget.binding?.dependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Return the page builder widget
    return widget.pageBuilder(
      context,
      widget.state,
    );
  }
}
