import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futsal_field_jepara/utils/router.gr.dart' as router_gr;

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthGuard extends RouteGuard {
  Future<bool> canNavigate(ExtendedNavigatorState navigator, String routeName,
      Object arguments) async {
    final user = await _auth.currentUser();
    if (user != null) {
      return true;
    }
    navigator.pushReplacementNamed(router_gr.Routes.signInScreen);
    return true;
  }
}
