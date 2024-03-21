import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:traxi/views/widgets/map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng _initialCameraPosition = const LatLng(0, 0);
  
  var _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation () async {
    try {
      setState(() { _isGettingLocation = true; });
      LocationData userLocation = await location.getLocation();
      setState(() {
        _isGettingLocation = false;
        _initialCameraPosition = LatLng(
          userLocation.latitude ?? 0, userLocation.longitude ?? 0);
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() { _isGettingLocation = false; });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isGettingLocation 
        ? const Center(child: CircularProgressIndicator(),) 
        : Stack(
          children: [
            UserMap(
             initialCameraPosition: _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              }, 
            ),
            Positioned(
              top: 20,
              right: 20,
              left: 20,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Where to?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                  prefixIcon: const Icon(Icons.search_rounded),
                  prefixIconColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                ),
                autocorrect: false,
                textInputAction: TextInputAction.search,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 50,
                child: Text(
                  'Tram Routes',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
            )
          ],
        ),
    );
  }
}
