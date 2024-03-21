import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserMap extends StatelessWidget {
  const UserMap({
    super.key, 
    required this.initialCameraPosition, 
    this.onMapCreated
  });

  final LatLng initialCameraPosition;
  final Function(GoogleMapController)? onMapCreated;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: initialCameraPosition,
        zoom: 16,
      ),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }
}
