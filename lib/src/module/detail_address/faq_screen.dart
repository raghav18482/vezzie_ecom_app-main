// import 'package:flutter/material.dart';

// class FAQScreen extends StatelessWidget {
//   const FAQScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FAQ'),
//       ),
//       body: ListView(
//         children: const <Widget>[
//           FAQItem(
//             question: '1. How can I place an order?',
//             answer:
//                 'To place an order, simply open the app, browse through the available groceries, add the items to your cart, and proceed to checkout. Follow the prompts to complete your order.',
//           ),
//           FAQItem(
//             question: '2. What payment methods do you accept?',
//             answer:
//                 'We accept various payment methods, including credit/debit cards, digital wallets like Apple Pay and Google Pay, and cash on delivery (COD) in select areas.',
//           ),
//           FAQItem(
//             question: '3. How can I track my order?',
//             answer:
//                 "You can track your order in real-time from the My Orders section of the app. Once your order is dispatched, you'll receive updates on its status and estimated delivery time.",
//           ),
//           FAQItem(
//             question: '4. Is there a minimum order amount?',
//             answer:
//                 'Yes, there is a minimum order amount required for delivery. This amount may vary depending on your location. You can check the minimum order amount in your area during checkout.',
//           ),
//           FAQItem(
//             question: '5. What if an item is out of stock?',
//             answer:
//                 'If an item is out of stock, you won\'t be able to add it to your cart. However, you can opt to receive notifications when the item is back in stock or choose an alternative product.',
//           ),
//           FAQItem(
//             question: '6. How can I contact customer support?',
//             answer:
//                 "You can contact our customer support team through the app. Navigate to the Help & Support section and choose the contact option that suits you, whether it's live chat, email, or phone.",
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FAQItem extends StatelessWidget {
//   final String question;
//   final String answer;

//   const FAQItem({super.key, required this.question, required this.answer});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: ExpansionTile(
//         title: Text(
//           question,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(answer),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:ecom_app/src/Resource/color/colors.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Support & FAQ'),
      ),
      body: ListView(
        children: <Widget>[
          Align(
              heightFactor: 2,
              child: Text(
                "Customer Support",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    shadows: const <Shadow>[
                      Shadow(
                        offset: Offset(1.0,
                            1.0), // Change these values to adjust the shadow offset
                        blurRadius:
                            2.0, // Change this value to adjust the shadow blur
                        color: AppColors
                            .buttonColor, // Change this color to adjust the shadow color
                      ),
                    ],
                    color: AppColors.buttonColor.withOpacity(.6),
                    //  fontWeight: FontWeight.bold,
                    fontSize: 22),
              )),
          const Divider(
            color: AppColors.dividerColour,
            thickness: .8,
          ),
          Column(
            children: const [
              Text(
                "We're here to",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
              ),
              Text(
                "help.",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
              ),
            ],
          ),
          const Align(
            heightFactor: 2,
            alignment: Alignment.center,
            child: Text(
                textAlign: TextAlign.center,
                "Have an issue with an order or feedback\nfor us? Our Support team is here to\nHelp you from 9 Am to 7 Pm."),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "For Anything Else",
              style: TextStyle(
                color: AppColors.pink,
                fontSize: 28,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Divider(
              color: AppColors.pink,
              thickness: 1.5,
            ),
          ),
          Transform.scale(
            scale: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Send us an Email to"),
                  const Text("info.vezzie@gmail.com"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .016,
                  ),
                  const Text("And Contact us to "),
                  const Text("+91 7424808477"),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .002,
          ),
          const Divider(
            thickness: .8,
            color: AppColors.dividerColour,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .002,
          ),
          const Divider(
            thickness: .8,
            color: AppColors.dividerColour,
          ),
          Align(
              heightFactor: 2,
              child: Text(
                "FAQ",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    shadows: const <Shadow>[
                      Shadow(
                        offset: Offset(1.0,
                            1.0), // Change these values to adjust the shadow offset
                        blurRadius:
                            2.0, // Change this value to adjust the shadow blur
                        color: AppColors
                            .buttonColor, // Change this color to adjust the shadow color
                      ),
                    ],
                    color: AppColors.buttonColor.withOpacity(.6),
                    //  fontWeight: FontWeight.bold,
                    fontSize: 22),
              )),
          const Divider(
            thickness: .8,
            color: AppColors.dividerColour,
          ),
          const FAQItem(
            question: '1. How to Place an Order?',
            answer:
                'Open the App, Login and Create an account, Choose your location, Go to the category you like, Browse and select items, Add items to your cart, Review your cart, Checkout, Apply Coupons, Click to continue, Add a new address or select your address, Enter Payment Information, Add a delivery tip (if desired), and then Confirm the Order.',
          ),
          const FAQItem(
            question: '2. How do I register?',
            answer:
                'You can register by opening the Vezzie App and logging in with your mobile number and OTP. Alternatively, you can register by clicking on the “Admin” section located at the bottom right side of the home page. Provide the required information in the form that appears and click Submit. We will send a one-time password (OTP) to verify your mobile number. After verification, you can start shopping on Vezzie.',
          ),
          const FAQItem(
            question: '3. What are the delivery charges?',
            answer:
                'We charge a nominal delivery fee of Rs 30 on all orders below a cart value of Rs 299 for selected categories at Vezzie. There are no delivery charges for orders above Rs 299.',
          ),
          const FAQItem(
            question: '4. Payment Mode?',
            answer:
                'We offer Cash on Delivery as a payment option. Additionally, you can pay online by scanning the QR code provided by our delivery boy or use our PhonePe ID - 9511513819@ybl (Vishnu Swami) for online payments.',
          ),
          const FAQItem(
            question: '5. Coupon not working?',
            answer:
                'Every coupon comes with a validity period, and if the validity is over, you cannot use the coupon. However, there will be more coupons available through our various promotions. Keep checking the coupons section for more offers.',
          ),
          const FAQItem(
            question: '6. Can I call and place an order?',
            answer:
                'Yes, we offer a call and place order service. Contact us at +91 74248 08477 to place an order.',
          ),
          const FAQItem(
            question: '7. How to Cancel my Order?',
            answer:
                'You can cancel your order by calling us at +91 74248 08477.',
          ),
          const FAQItem(
            question: '8. How to Receive a Refund?',
            answer:
                'If you cancel an order placed with Cash on Delivery payment mode, our delivery boy will collect the canceled order, and you will receive the refund. If you cancel an order placed through online or UPI payment mode, you will receive the refund within 12 hours of the canceled order.',
          ),
          const FAQItem(
            question: '9. Want to work with us?',
            answer:
                'Thank you for your interest in working with Vezzie. Kindly share your updated resume with us at info.vezzie@gmail.com and contact us at +91 74248 08477. Someone from our Human Resources team will connect with you if you fulfill our required criteria. We wish you all the best with your application!',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
