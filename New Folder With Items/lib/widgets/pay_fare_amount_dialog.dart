import 'package:chalo_kart_user/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Import the RateDriverScreen
import '../screens/rate_driver_screen.dart';

class PayFareAmountDialog extends StatefulWidget {
  final double fareAmount;
  final String? assignedDriverId; // Add driver ID as a parameter

  const PayFareAmountDialog({
    super.key,
    required this.fareAmount,
    this.assignedDriverId, // Make it optional but will be needed for rating
  });

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");

  Future<void> deductAmountFromWallet(String newWalletAmount) async {
    try {
      // Update wallet amount in Firebase
      userRef
          .child(firebaseAuth.currentUser!.uid)
          .update({"wallet_amount": newWalletAmount});

      // Update local state
      setState(() {
        userModelCurrentInfo!.wallet_amount = newWalletAmount;
      });

      Fluttertoast.showToast(msg: "Payment Successful!");

      // Pop the dialog and return status
      Navigator.pop(context, "Amount Deducted from Wallet");
      print("Amount Deducted from Wallet");

      // Navigate to RateDriverScreen instead of SplashScreen
      if (widget.assignedDriverId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => RateDriverScreen(
              assignedDriverId: widget.assignedDriverId!,
            ),
          ),
        );
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: Failed to process payment");
      print("Error during payment: $error");
    }
  }

  void handlePayment() {
    try {
      if (userModelCurrentInfo?.wallet_amount == "") {
        Fluttertoast.showToast(msg: "Wallet information not available");
        return;
      }

      // Parse amounts carefully
      double currentWalletAmount = double.parse(userModelCurrentInfo!.wallet_amount!);

      // Use widget.fareAmount directly
      double fareAmount = widget.fareAmount;

      // Debug prints to verify values
      print("Current wallet amount: $currentWalletAmount");
      print("Fare to deduct: $fareAmount");

      // Validate if user has sufficient balance
      if (currentWalletAmount < fareAmount) {
        Fluttertoast.showToast(msg: "Insufficient wallet balance: ₹${currentWalletAmount}");
        return;
      }

      // Calculate new amount
      double newAmount = currentWalletAmount - fareAmount;
      String newWalletAmount = newAmount.toStringAsFixed(0);

      print("New wallet amount will be: $newWalletAmount"); // Debug print

      // Perform deduction
      deductAmountFromWallet(newWalletAmount);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error processing payment");
      print("Payment processing error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              "Fare Amount",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "₹${widget.fareAmount.toStringAsFixed(0)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "This is the total trip fare amount",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(18),
              child: ElevatedButton(
                onPressed: () {
                  handlePayment(); // Keep the existing payment handling
                  print("Payment handle called");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pay From Wallet",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${widget.fareAmount.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}