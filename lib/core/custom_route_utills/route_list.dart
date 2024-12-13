import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../route/app_route.dart';
import 'binding_wrapper.dart';
import 'custom_navigation.dart';
import 'custom_route.dart';

/// Checks if a user is currently logged in by verifying FirebaseAuth instance.
bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

class GetRoutesPages {
  static var user =
      FirebaseAuth.instance.currentUser; // Holds the current Firebase user.

  /// Generates a list of GoRouter routes based on the predefined `AppRoutes`.
  /// - Applies redirection for authentication if the user is not logged in.
  static List<GoRoute> getGoRouterRoutes() {
    return AppRoutes.routes.map((route) {
      return GoRoute(
        name: route.name, // Sets the route name
        path: route.name, // Sets the route path
        redirect: (context, state) {
          final path = state.uri.path;
          // List of paths to exclude from redirection (e.g., public pages).
          final excludedPaths = [
            //////////////////////////////////////
          ];
          // Redirects to '/auth' if not logged in and path is not excluded.
          if (!isLoggedIn && !excludedPaths.contains(path)) {
            return '/auth';
          }
          return null; // No redirection if already logged in.
        },
        builder: (context, state) => BindingWrapper(
          binding: route.binding, // Applies binding for dependencies.
          pageBuilder: route.goRoutePage, // Builds the actual page.
          state: state, // Passes current route state.
        ),
        routes: route.children
                ?.map((childRoute) => buildGoRoute(
                    childRoute)) // Recursively builds child routes.
                .toList() ??
            [],
      );
    }).toList();
  }

  /// Helper function to construct a GoRoute for a given `CustomRoute`.
  /// - Supports nested routes and extracts route names and paths.
  static GoRoute buildGoRoute(CustomRoute route) {
    final name = extractLastStringFromSlashs(
        route.name); // Extracts the route's last segment as the name.
    final path = removeFirstSlash(extractLastStringFromSlashs(
        route.name)); // Removes leading slash for path.
    return GoRoute(
      name: name,
      path: path,
      builder: (context, state) => BindingWrapper(
        binding: route.binding, // Applies binding to the page.
        pageBuilder: route.goRoutePage, // Builds the page for the route.
        state: state,
      ),
      routes: route.children
              ?.map((childRoute) => buildGoRoute(
                  childRoute)) // Builds nested child routes if any.
              .toList() ??
          [],
    );
  }

  /// Builds a `GetPage` for a given `CustomRoute` which is compatible with GetX routing.
  /// - Applies binding and recursively builds child routes.
  static GetPage buildGetRoute(CustomRoute route) {
    final name = extractLastStringFromSlashs(
        route.name); // Extracts route name from the path.
    debugPrint("Get: $name"); // Debug print for route name.
    return GetPage(
      name: name,
      page: route.getPage, // Specifies the page builder for GetX.
      binding: route.binding, // Applies dependency binding.
      children: route.children
              ?.map((childRoute) =>
                  buildGetRoute(childRoute)) // Builds child routes recursively.
              .toList() ??
          [],
    );
  }

  /// Generates a list of `GetPage` routes for GetX based on `AppRoutes`.
  /// - Supports nested routes and applies binding for dependencies.
  static List<GetPage> getGetXPages() {
    return AppRoutes.routes.map((route) {
      return GetPage(
        binding: route.binding, // Applies the defined binding.
        name: route.name, // Sets route name.
        page: route.getPage, // Defines page builder.
        children: route.children
                ?.map((childRoute) =>
                    buildGetRoute(childRoute)) // Recursively adds children.
                .toList() ??
            [],
      );
    }).toList();
  }
}

/// Utility function to remove the first slash from a route path if it exists.
String removeFirstSlash(String route) {
  if (route.startsWith('/')) {
    return route.substring(1);
  }
  return route;
}
