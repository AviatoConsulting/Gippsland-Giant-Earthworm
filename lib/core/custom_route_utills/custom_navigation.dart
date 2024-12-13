import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/main.dart';
import 'package:go_router/go_router.dart';

/// A helper class to navigate between routes, using either GoRouter or GetX
/// based on the `isUseGoRouter` boolean flag defined in `main.dart`.
class CustomNavigationHelper {
  /// Navigates to a specified route.
  /// Uses `GoRouter` if `isUseGoRouter` is `true`, otherwise uses `GetX` for navigation.
  ///
  /// - [context]: The current build context.
  /// - [routeName]: Name of the route to navigate to.
  /// - [queryParameters]: Query parameters to include in the route.
  /// - [arguments]: Extra arguments to pass to the route.
  /// - [replace]: If `true`, replaces the current route with the new one.
  static void navigateTo({
    required BuildContext context,
    required String routeName,
    Map<String, String>? queryParameters,
    Map<String, String>? arguments,
    bool replace = false,
  }) {
    if (isUseGoRouter) {
      // GoRouter navigation, optionally with query parameters and extra arguments.
      if (queryParameters != null && arguments != null) {
        GoRouter.of(context).goNamed(
          extractLastStringFromSlashs(routeName),
          queryParameters: queryParameters,
          extra: arguments,
        );
      } else if (queryParameters != null) {
        GoRouter.of(context).goNamed(
          extractLastStringFromSlashs(routeName),
          queryParameters: queryParameters,
        );
      } else if (arguments != null) {
        GoRouter.of(context).goNamed(
          extractLastStringFromSlashs(routeName),
          extra: arguments,
        );
      } else {
        GoRouter.of(context).goNamed(extractLastStringFromSlashs(routeName));
      }
    } else {
      // GetX navigation with parameters and arguments.
      debugPrint("Route using getX\nParameters: $queryParameters");
      debugPrint("RouteName: $routeName");
      replace
          ? Get.offNamed(routeName,
              parameters: queryParameters, arguments: arguments)
          : Get.toNamed(routeName,
              parameters: queryParameters, arguments: arguments);
    }
  }

  /// Pops the current route from the navigation stack.
  /// Uses `GoRouter` if `isUseGoRouter` is `true`, otherwise uses `GetX` to go back.
  static void pop(BuildContext context) {
    if (isUseGoRouter) {
      if (GoRouter.of(context).canPop()) {
        GoRouter.of(context).pop();
      } else {
        // Optionally handle browser back navigation.
        // html.window.history.back();
      }
    } else {
      if (Get.isPopGestureEnable) {
        Get.back();
      } else {
        // Optionally handle browser back navigation.
        // html.window.history.back();
      }
    }
  }

  // Constructs a route URL by extracting the last section of a given route name.
  // Useful for when route names contain multiple slashes.
}

String extractLastStringFromSlashs(String input) {
  input = input.trim(); // Remove leading or trailing spaces.
  List<String> parts = input.split('/'); // Split the string by '/'.
  if (parts.length < 3 || parts.last.isEmpty) {
    return input; // Return the input if there aren't enough parts or if last is empty.
  }
  // Return the last relevant part of the route.
  return '/${parts.sublist(2).join('/')}';
}
