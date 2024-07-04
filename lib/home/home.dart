import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nav_history/history/history.dart';
import 'package:nav_history/result/results.dart';
import 'package:nav_history/widgets/header_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  String _startLocation = '';
  String _endLocation = '';
  MapboxMapController? mapControllerStart;
  MapboxMapController? mapControllerEnd;

  LatLng? _startLatLng;
  LatLng? _endLatLng;

  Future<void> _geocodeLocation(String location, bool isStart) async {
    final response = await http.get(
      Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$location.json?access_token=sk.eyJ1IjoiYWtoaWxsZXZha3VtYXIiLCJhIjoiY2x4MDcxM3JlMGM5YTJxc2Q1cHc4MHkyZSJ9.awWNy5HErR8ooOddFDR6Gg',
      ),
    );
    final data = json.decode(response.body);
    final firstResult = data['features'][0]['center'];
    final latLng = LatLng(firstResult[1], firstResult[0]);

    setState(() {
      if (isStart) {
        _startLatLng = latLng;
        _startLocation = location;
        _addMarkerStart(latLng, 'Start');
      } else {
        _endLatLng = latLng;
        _endLocation = location;
        _addMarkerEnd(latLng, 'End');
      }
    });
  }

  void _onMapCreatedStart(MapboxMapController controller) {
    mapControllerStart = controller;
  }

  void _onMapCreatedEnd(MapboxMapController controller) {
    mapControllerEnd = controller;
  }

  void _addMarkerStart(LatLng latLng, String title) {
    mapControllerStart?.addSymbol(
      SymbolOptions(
        geometry: latLng,
        iconSize: 1.0,
        iconImage: 'assets/icons/marker.png',
        // textField: title,
        textOffset: const Offset(0, 2),
      ),
    );
    mapControllerStart?.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void _addMarkerEnd(LatLng latLng, String title) {
    mapControllerEnd?.addSymbol(
      SymbolOptions(
        geometry: latLng,
        iconSize: 1.0,
        iconImage: 'assets/icons/marker.png',
        // textField: title,
        textOffset: const Offset(0, 2),
      ),
    );
    mapControllerEnd?.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const HeaderWidget(),
            Positioned(
              top: 200.0,
              left: 0.0,
              right: 0.0,
              child: Card(
                elevation: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _startController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Start Location',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _geocodeLocation(value, true);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: MapboxMap(
                          accessToken:
                              "sk.eyJ1IjoiYWtoaWxsZXZha3VtYXIiLCJhIjoiY2x4MDcxM3JlMGM5YTJxc2Q1cHc4MHkyZSJ9.awWNy5HErR8ooOddFDR6Gg",
                          onMapCreated: _onMapCreatedStart,
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(8.524139, 76.936638),
                            zoom: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 480.0,
              left: 0.0,
              right: 0.0,
              child: Card(
                elevation: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _endController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: 'End Location',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _geocodeLocation(value, false);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: MapboxMap(
                          accessToken:
                              "sk.eyJ1IjoiYWtoaWxsZXZha3VtYXIiLCJhIjoiY2x4MDcxM3JlMGM5YTJxc2Q1cHc4MHkyZSJ9.awWNy5HErR8ooOddFDR6Gg",
                          onMapCreated: _onMapCreatedEnd,
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(8.524139, 76.936638),
                            zoom: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ResultsScreen.routeName, arguments: {
                          'startLocation': _startLocation,
                          'endLocation': _endLocation,
                          'startLatLng': _startLatLng,
                          'endLatLng': _endLatLng
                        });
                      },
                      child: const Text(
                        'Navigate',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(HistoryScreen.routeName);
                      },
                      child: const Text(
                        'Saved',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
