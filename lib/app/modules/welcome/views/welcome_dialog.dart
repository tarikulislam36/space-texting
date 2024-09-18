import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: GlossyContainer(
          height: 60.h,
          width: 90.w,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 90.w,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 36, 3, 97)),
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.find<WelcomeController>().startBack();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  "Space Texting & Calling",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                10.kheightBox,
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Space Texting can be a strange and wonderful place, full of people, ideas, and communities that might be new and different. Treat everyone with respect, and you'll have a great time. Behave poorly, and you'll be asked you leave.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Read our Privacy Policy. By tapping “Start now” you agree to our Terms & Policies.",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                Spacer(),
                CustomElevatedButton(
                  height: 50,
                  width: 70.w,
                  buttonText: "Accept",
                  onPressed: () {
                    Get.toNamed(Routes.ONBOARDING);
                  },
                ),
                20.kheightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
