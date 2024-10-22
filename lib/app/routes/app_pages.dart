import 'package:get/get.dart';

import '../modules/allowNotification/bindings/allow_notification_binding.dart';
import '../modules/allowNotification/views/allow_notification_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chatScreen/bindings/chat_screen_binding.dart';
import '../modules/chatScreen/views/chat_screen_view.dart';
import '../modules/editProfile/bindings/edit_profile_binding.dart';
import '../modules/editProfile/views/edit_profile_view.dart';
import '../modules/getStarted/bindings/get_started_binding.dart';
import '../modules/getStarted/views/get_started_view.dart';
import '../modules/getUserDetails/bindings/get_user_details_binding.dart';
import '../modules/getUserDetails/views/get_user_details_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loginSignup/bindings/login_signup_binding.dart';
import '../modules/loginSignup/views/login_signup_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profileScreen/bindings/profile_screen_binding.dart';
import '../modules/profileScreen/views/profile_screen_view.dart';
import '../modules/selectChat/bindings/select_chat_binding.dart';
import '../modules/selectChat/views/select_chat_view.dart';
import '../modules/showImage/bindings/show_image_binding.dart';
import '../modules/showImage/views/show_image_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/signupSuccess/bindings/signup_success_binding.dart';
import '../modules/signupSuccess/views/signup_success_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/videoCall/bindings/video_call_binding.dart';
import '../modules/videoCall/views/video_call_view.dart';
import '../modules/viewProfile/bindings/view_profile_binding.dart';
import '../modules/viewProfile/views/view_profile_view.dart';
import '../modules/voiceCall/bindings/voice_call_binding.dart';
import '../modules/voiceCall/views/voice_call_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.GET_STARTED,
      page: () => const GetStartedView(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SIGNUP,
      page: () => const LoginSignupView(),
      binding: LoginSignupBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_SUCCESS,
      page: () => const SignupSuccessView(),
      binding: SignupSuccessBinding(),
    ),
    GetPage(
      name: _Paths.ALLOW_NOTIFICATION,
      page: () => const AllowNotificationView(),
      binding: AllowNotificationBinding(),
    ),
    GetPage(
      name: _Paths.GET_USER_DETAILS,
      page: () => GetUserDetailsView(),
      binding: GetUserDetailsBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => const NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => const ChatScreenView(),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const ProfileScreenView(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_CALL,
      page: () => const VideoCallView(),
      binding: VideoCallBinding(),
    ),
    GetPage(
      name: _Paths.VOICE_CALL,
      page: () => const VoiceCallView(),
      binding: VoiceCallBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_PROFILE,
      page: () => const ViewProfileView(),
      binding: ViewProfileBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_CHAT,
      page: () => const SelectChatView(),
      binding: SelectChatBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_IMAGE,
      page: () => const ShowImageView(),
      binding: ShowImageBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
  ];
}
