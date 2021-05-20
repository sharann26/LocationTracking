import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isVisible = false;
  Timer timer;
  String currentLocation = '';
  String updatedCurrentLocation = '';
  void _getLocation() async {
    final position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lastPosition = await Geolocator().getLastKnownPosition();

    print(updatedCurrentLocation);

    setState(() {
      isVisible = true;
      currentLocation = "${position.latitude}, ${position.longitude}";
      updatedCurrentLocation = "$lastPosition";
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(seconds: 5),
      (Timer t) => {
        if (isVisible) {_getLocation()}
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Visibility(
          visible: isVisible,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                color: Colors.yellowAccent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.02, horizontal: width * 0.04),
                  width: width * 0.75,
                  height: height * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Current Location",
                        style: TextStyle(
                            color: Colors.black, fontSize: height * 0.035),
                      ),
                      Text(
                        "$updatedCurrentLocation",
                        style: TextStyle(
                            color: Colors.black87, fontSize: height * 0.025),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Location',
        backgroundColor: isVisible ? Colors.redAccent : Colors.green,
        child: isVisible ? Icon(Icons.refresh) : Icon(Icons.location_pin),
      ),
    );
  }
}
