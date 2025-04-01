import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';
import 'package:flutter/material.dart';

class OurAddressScreen extends StatelessWidget {
  const OurAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Address"),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Delivery Areas",
                style: TextStyle(
                    fontSize: 22,
                    color: AppColors.commonTextColor,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.underline),
              ),
            ),
            Align(
              heightFactor: 2,
              alignment: Alignment.center,
              child: Text(
                "We are providing 30 minutes grocery delivery only in Bikaner city of Rajasthan, If any order is out side Bikaner city then it may take time to deliver that order and consumer will have to pay delivery  charges separately."
                    .trim(),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.commonTextColor,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Image.asset(
              AppImages.scooter,
              width: MediaQuery.of(context).size.width * .35,
              //   colorBlendMode: BlendMode.color,
              //    color: AppColors.buttonColor.withOpacity(.8),
            ),
            const Divider(
              thickness: 1,
              color: Color(0xff42271B),
            ),
            const Text(
              "CORPORATE OFFICE :",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.commonTextColor,
                fontStyle: FontStyle.normal,
              ),
            ),
            const Text(
                "Near Power House,\nAntyodiya Nagar,Bikaner,\nRajasthan - 334004"),
            const Text("Mob. - 74248 08477"),
            const Text("Email - info.vizze@gmail.com")
          ],
        ),
      ),
    );
  }
}
