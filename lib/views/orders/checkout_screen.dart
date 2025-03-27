import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find();
  final OrderController orderController = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  PageController _pageController = PageController();
  int _currentStep = 0;
  String selectedPaymentMethod = "Wallet / UPI";

  void goToNextStep() {
    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Stack(
        children: [
          Column(
            children: [
              // Step Indicator
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Step 1: Delivery (with conditional icon)
                    InkWell(
                      onTap: () {
                        goToPreviousStep();
                      },
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // White background for the icon
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: _currentStep == 0
                            ? Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue)
                            : Icon(Icons.check, color: Colors.green),
                      ),
                    ),
                    SizedBox(width: 8),

                    // Delivery Step Text (Clickable)
                    InkWell(
                      onTap: () {
                        goToPreviousStep();
                      },
                      child: Text(
                        "Delivery",
                        style: TextStyle(
                          fontSize: _currentStep == 0 ? 18: 14,
                          fontWeight: FontWeight.bold,
                          color: _currentStep == 0 ? Colors.black : Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    // Step Divider (Arrow)
                    //step 2: Payment (with circular icon)
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                          Icons.arrow_forward_ios_rounded, color: _currentStep == 0 ? Colors.grey : Colors.blue
                      ),
                    ),
                    SizedBox(width: 8),

                    // Payment Step Text
                    Text(
                      "Payment",
                      style: TextStyle(
                        fontSize: _currentStep == 1 ? 18: 14,
                        fontWeight: FontWeight.bold,
                        color: _currentStep == 1 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildDeliveryStep(),
                    buildPaymentStep(),
                  ],
                ),
              ),
            ],
          ),
          // Fixed Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildBottomBar(
              onPressed: _currentStep == 0 ? goToNextStep : () {
                orderController.placeOrder(
                  customerName: nameController.text,
                  phoneNumber: phoneController.text,
                  address: addressController.text,
                  cartItems: cartController.cartItems,
                  totalPrice: cartController.totalPrice,
                );
              },
              buttonText: _currentStep == 0 ? "CONFIRM" : "PROCEED",
              buttonIcon: _currentStep == 0 ? Icons.check : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Delivery Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.location_on, color: Colors.blue),
              title: Text("Aftab Shah 9481924680"),
              subtitle: Text("Hans Egedevej 29, Nuuk, Greenland-795001"),
              trailing: IconButton(
                icon: Icon(Icons.add_circle, color: Colors.blue),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(height: 20),
          Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                var item = cartController.cartItems[index];
                var product = item.keys.first;
                int quantity = item.values.first;

                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("Qty: $quantity x ₹${product.price}"),
                  trailing: Text("₹${product.price * quantity}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Ensures text stays left-aligned
        children: [
          // Centered Offer Card
          Center(
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "GET EXTRA 5% OFF with Online Payment. Simply use pay as advance . T&C.",
                  style: TextStyle(fontSize: 14, ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Payment Method Title (Left-aligned)
          Text(
            "Payment Method",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          // Payment Options
          Expanded(
            child: Column(
              children: [
                buildPaymentOption("Wallet / UPI"),
                buildPaymentOption("Cash on Delivery"),
              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget buildPaymentOption(String method) {
    bool isSelected = selectedPaymentMethod == method;

    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = method),
      child: Stack(
        clipBehavior: Clip.none, // Allows animation to overflow the card
        children: [
          // Payment Option Card
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: isSelected ? Colors.pinkAccent.withOpacity(0.5) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Payment Method Text
                Text(
                  method,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),

                // Checkmark Icon (Only when selected)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.grey[300],
                  ),
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? Colors.greenAccent : Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Lottie Animation (Only shown when selected)
          if (isSelected)
            Positioned(
              top: -10, // Adjust position to place above the card
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  selectedPaymentMethod == "Wallet / UPI" ?'assets/animations/gpay.json':"assets/animations/cashpay.json", // Replace with your Lottie animation file
                  width: 100,
                  height: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }



  Widget buildBottomBar({required VoidCallback onPressed, required String buttonText, required IconData buttonIcon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.black),
              SizedBox(width: 5),
              Text(
                "Total: ₹${cartController.totalPrice}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400],
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              children: [
                Text(buttonText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 5),
                Icon(buttonIcon, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
