import 'package:flutter/material.dart';

class DeliveryIcon extends StatelessWidget {
  final bool isDelivered;

  const DeliveryIcon({Key? key, required this.isDelivered}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(

      children: [
        Image(
          image: AssetImage('assets/delivery-man.png'),
          width: 24,
          height: 24,
        )
,
        (!isDelivered)?
          Text("Take Away Only"):Text("Dilevery Available")
      ],
    );
  }
}
