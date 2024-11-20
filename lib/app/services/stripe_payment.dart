import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentService {
  static const String firebaseFunctionUrl =
      'https://us-central1-space-text-1a5c7.cloudfunctions.net/createPaymentIntent';

  Future<String?> createPaymentIntent(String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse(firebaseFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': calculateAmount(amount),
          'currency': currency,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['clientSecret'];
      } else {
        print('Failed to create Payment Intent');
        return null;
      }
    } catch (error) {
      print('Error creating Payment Intent: $error');
      return null;
    }
  }

  Future<void> processPayment(String amount, String currency) async {
    final clientSecret = await createPaymentIntent(amount, currency);
    if (clientSecret == null) return;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Your Business Name',
      ),
    );

    await Stripe.instance.presentPaymentSheet();
    final oneMonthFromNow =
        DateTime.now().add(const Duration(days: 30)); // Add 30 days
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"membership": Timestamp.fromDate(oneMonthFromNow)});

    Get.snackbar("Success", "Membership Activated");
  }

  int calculateAmount(String amount) {
    final amountInCents = (double.parse(amount) * 100).toInt();
    return amountInCents;
  }
}
