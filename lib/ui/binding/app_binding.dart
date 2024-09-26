import 'package:get/get.dart';
import '../controller/call_controller.dart';
import '../controller/login_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => CallController());
  }

}