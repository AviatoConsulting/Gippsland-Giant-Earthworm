// Custom Route for Getx and GoRouter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CustomRoute {
  final String name;
  final Widget Function() getPage;
  final Widget Function(BuildContext, GoRouterState) goRoutePage;
  final Bindings? binding; // add binding (optional)
  final Map<String, String>? pathParameter; // add pathparameter (optional)
  final List<CustomRoute>? children; // Add children routes (optional)

  CustomRoute({
    required this.name,
    required this.getPage,
    required this.goRoutePage,
    this.binding,
    this.pathParameter,
    this.children,
  });
}
