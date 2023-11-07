import 'package:delivery/main.dart';
import 'package:flutter/material.dart';

class LocationCoordinates extends StatefulWidget {
  const LocationCoordinates({super.key});

  @override
  State<LocationCoordinates> createState() => _LocationCoordinatesState();
}

class _LocationCoordinatesState extends State<LocationCoordinates> {
  TextEditingController PickupLatitude = TextEditingController();
  TextEditingController PickupLongitude = TextEditingController();
  TextEditingController DeliveryLatitude = TextEditingController();
  TextEditingController DeliveryLongitude = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Coordinates"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PickupPoint Latitude"),
              TextField(
                controller: PickupLatitude,
              ),
              SizedBox(height: 20),
              Text("PickupPoint Longitude"),
              TextField(
                controller: PickupLongitude,
              ),
              SizedBox(height: 20),
              Text("Delivery Latitude"),
              TextField(
                controller: DeliveryLatitude,
              ),
              SizedBox(height: 20),
              Text("Delivery Longitude"),
              TextField(
                controller: DeliveryLongitude,
              ),
              SizedBox(
                height: 150,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ItemPickupDeliveryPage(
                                pickupLatitudePoint: PickupLatitude.text,
                                pickupLongitudePoint: PickupLongitude.text,
                                deliveryLatitudetudePoint:
                                    DeliveryLatitude.text,
                                deliveryLongitudePoint: DeliveryLongitude.text,
                              )));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 50, right: 50),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Text('Get Location'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
