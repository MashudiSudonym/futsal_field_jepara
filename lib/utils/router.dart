import 'package:auto_route/auto_route_annotations.dart';
import 'package:futsal_field_jepara/screen/create_schedule.dart';
import 'package:futsal_field_jepara/screen/create_user_screen.dart';
import 'package:futsal_field_jepara/screen/edit_profile.dart';
import 'package:futsal_field_jepara/screen/futsal_field_information.dart';
import 'package:futsal_field_jepara/screen/main_screen.dart';
import 'package:futsal_field_jepara/screen/invoice_screen.dart';
import 'package:futsal_field_jepara/screen/profile_screen.dart';
import 'package:futsal_field_jepara/screen/sign_in_screen.dart';
import 'package:futsal_field_jepara/screen/splash_screen.dart';
import 'package:futsal_field_jepara/utils/route_guards.dart';

@CupertinoAutoRouter(
  generateNavigationHelperExtension: true,
  generateArgsHolderForSingleParameterRoutes: true,
  routesClassName: 'Routes',
)
class $Router {
  @initial
  @GuardedBy([AuthGuard])
  SplashScreen splashScreen;

  SignInScreen signInScreen;

  @GuardedBy([AuthGuard])
  CreateUserScreen createUserScreen;

  @GuardedBy([AuthGuard])
  MainScreen mainScreen;

  @GuardedBy([AuthGuard])
  ProfileScreen profileScreen;

  @MaterialRoute()
  @GuardedBy([AuthGuard])
  FutsalFieldInformation futsalFieldInformation;

  @GuardedBy([AuthGuard])
  CreateSchedule createSchedule;

  @GuardedBy([AuthGuard])
  EditProfile editProfile;

  @GuardedBy([AuthGuard])
  InvoiceScreen invoiceScreen;
}
