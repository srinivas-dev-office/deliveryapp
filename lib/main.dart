import 'dart:ffi';

import 'package:delivery/Screens/location_coordinates.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationCoordinates(),
      //ItemPickupDeliveryPage(),
    );
  }
}

class ItemPickupDeliveryPage extends StatefulWidget {
  final String pickupLatitudePoint;
  final String pickupLongitudePoint;
  final String deliveryLatitudetudePoint;
  final String deliveryLongitudePoint;
  const ItemPickupDeliveryPage(
      {super.key,
      required this.pickupLatitudePoint,
      required this.pickupLongitudePoint,
      required this.deliveryLatitudetudePoint,
      required this.deliveryLongitudePoint});
  @override
  _ItemPickupDeliveryPageState createState() => _ItemPickupDeliveryPageState();
}

class _ItemPickupDeliveryPageState extends State<ItemPickupDeliveryPage> {
  String deliveryStatus = "progress";
  // String itemStatus = "notpicked";
  //   late Position currentLocation;
  // LatLng pickupLocation = LatLng(PICKUP_LATITUDE, PICKUP_LONGITUDE);
  double distanceThreshold = 50.0;
  late GoogleMapController mapController;
  late LatLng pickupLocation;
  late LatLng deliveryLocation;

  String locationMessage = '';
  late LatLng currentLocation;
  // late LatLng currentLocation;

  Future<void> checkLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      getUserLocation();
    } else {
      requestLocationPermission();
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      getUserLocation();
    } else {
      setState(() {
        locationMessage = 'Location permission denied.';
      });
    }
  }

  void getUserLocation() {
    Geolocator.getPositionStream(

            // desiredAccuracy: LocationAccuracy.high,
            // distanceFilter: 10, // Update location every 10 meters
            )
        .listen((position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });

      double distanceToPickup = Geolocator.distanceBetween(
        // currentLocation.latitude,
        position.latitude,
        position.longitude,
        // currentLocation.longitude,
        pickupLocation.latitude,
        pickupLocation.longitude,
      );

      double distanceTodelivery = Geolocator.distanceBetween(
        // currentLocation.latitude,
        position.latitude,
        position.longitude,
        // currentLocation.longitude,
        deliveryLocation.latitude,
        deliveryLocation.longitude,
      );

      if (distanceToPickup < distanceThreshold) {
        setState(() {
          deliveryStatus = "pickup";
          //itemStatus = "outforDelivery";
        });
        handleNearPickup();
      }
      if (distanceTodelivery < distanceThreshold) {
        setState(() {
          deliveryStatus = "deliver";
        });
        handleNeaedelivery();
      }
    });
  }

  void handleNeaedelivery() {
    Fluttertoast.showToast(
        msg: "Reached Delivery Destination",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0);

    print('You are near the pickup location!');
  }

  void handleNearPickup() {
    Fluttertoast.showToast(
        msg: "Reached pickup Destination",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0);

    print('You are near the pickup location!');
  }

  // Future<void> getUserLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     setState(() {
  //       currentLocation = LatLng(position.latitude, position.longitude);
  //       locationMessage =
  //           'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       locationMessage = 'Error getting location: $e';
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getUserLocation();
    currentLocation = LatLng(0.0, 0.0);
    checkLocationPermission();

/////////////////////////////////
    pickupLocation = LatLng(double.parse(widget.pickupLatitudePoint),
        double.parse(widget.pickupLongitudePoint)); //
    // Shankar villas   // 17.448185408706106, 78.38005925220045
    deliveryLocation = LatLng(double.parse(widget.deliveryLatitudetudePoint),
        double.parse(widget.deliveryLongitudePoint));
////////////////////////

    // pickupLocation =
    //     LatLng(17.448185408706106, 78.38005925220045); // SVR PG,vibho tech
    // // LatLng(17.49952035631524, 78.39568568485878); // Shankar villas   // 17.448185408706106, 78.38005925220045
    // deliveryLocation = LatLng(17.447074129752693,
    //     78.38116790843827); // 17.447074129752693, 78.38116790843827  // Shri tirumala
    // LatLng(17.44710345951432,
    //     78.39437535201895); // Brownbear   //   17.44710345951432, 78.38116410021044
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Pickup and Delivery'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 15.0,
                ),
                myLocationEnabled: true,
                // initialCameraPosition: CameraPosition(
                //   target: pickupLocation,
                //   zoom: 10.0,
                // ),
                markers: {
                  Marker(
                    markerId: MarkerId('pickup'),
                    position: pickupLocation,
                    infoWindow: InfoWindow(title: 'Pickup Location'),
                  ),
                  Marker(
                    markerId: MarkerId('delivery'),
                    position: deliveryLocation,
                    infoWindow: InfoWindow(title: 'Delivery Location'),
                  ),
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: currentLocation,
                    infoWindow: InfoWindow(
                      title: 'Your Location',
                    ),
                  ),
                },
              ),
            ),
            //  Text(widget.pickupLatitudePoint ?? ""),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Pick Up Item',
                style: TextStyle(
                    color: deliveryStatus == "pickup"
                        ? Colors.blue
                        : Colors.black.withOpacity(0.5)),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Deliver Item',
                style: TextStyle(
                    color: deliveryStatus == "deliver"
                        //  &&
                        // itemStatus == "outforDelivery"
                        ? Colors.blue
                        : Colors.black.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
