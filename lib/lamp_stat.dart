import 'package:flutter/material.dart';
import 'package:testfirebase/carbon_footprint.dart';
import 'package:testfirebase/chat.dart';
import 'package:testfirebase/dashboard.dart';
import 'package:testfirebase/main.dart';

import 'dart:async';
import 'dart:math'; // Import to generate random values

class ecolight_stat extends StatefulWidget {
  const ecolight_stat({super.key});

  @override
  State<ecolight_stat> createState() => _ecolight_statState();
}

class _ecolight_statState extends State<ecolight_stat> {
  // Initialize the data with default values.
  Map<String, dynamic> latestData = {
    'light': '0',
    'temperature': '0',
    'carbon': '0',
    'algaeBiomass': 'False',
  };

  @override
  void initState() {
    super.initState();
    // Fetch data initially
    generateRandomData();
    // Set up a timer to generate data every few seconds
    Timer.periodic(Duration(seconds: 5), (Timer t) => generateRandomData());
  }

  // Function to generate random data within specified ranges
  void generateRandomData() {
    final random = Random();
    
    setState(() {
      latestData = {
        'light': (290 + random.nextInt(21)).toString(), // 290 to 310 lx
        'temperature': (28 + random.nextInt(3)).toString(), // 28 to 30 °C
        'carbon': (700 + random.nextInt(31)).toString(), // 700 to 730 ppm
        'algaeBiomass': random.nextBool().toString() // Random true/false
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: EcolightMeasuresScreen(data: latestData),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Color.fromRGBO(173, 191, 127, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: const Icon(
                Icons.pie_chart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => dashboard()),
                );
              }),
          IconButton(
              icon: const Icon(
                Icons.lightbulb,
                color: Colors.black,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CarbonFootprintTracker()),
                );
              }),
          IconButton(
              icon: Image.asset('chat-w.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => chat(carbonFootprint: '10', showAddRecordButton: false)),
                );
              }),
        ],
      ),
    );
  }
}

class EcolightMeasuresScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const EcolightMeasuresScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: Text(
                  'Ecolight \nMeasures',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(children: [
                    StatCard(
                      img: 'light.png',
                      title: 'Light Intensity',
                      value: data['light'],
                      color: Theme.of(context).colorScheme.secondary,
                      unit: 'lx',
                    ),
                    SizedBox(height: 30),
                    StatCard(
                      img: 'co2.png',
                      title: 'Carbon Dioxide Level',
                      value: data['carbon'],
                      color: Theme.of(context).colorScheme.tertiary,
                      unit: 'ppm',
                    ),
                    SizedBox(height: 30),
                    StatCard(
                      img: 'temparature.png',
                      title: 'Temperature',
                      value: data['temperature'],
                      color: Theme.of(context).colorScheme.surface,
                      unit: '°C',
                    ),
                    SizedBox(height: 30),
                    StatCard(
                      img: 'algaeBiomass.png',
                      title: 'Algae Bloom Status',
                      value: '50',
                      color: Theme.of(context).colorScheme.primary,
                      unit: '',
                    ),
                  ]),
                ),
                Image.asset('lamp.png', height: 535),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String img;
  final String title;
  final String value;
  final Color color;
  final String unit;

  const StatCard({
    super.key,
    required this.img,
    required this.title,
    required this.value,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: color,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(25, 8, 8, 8),
          minVerticalPadding: 10,
          leading: Image.asset(
            img,
            height: 50,
            width: 50,
          ),
          title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10)
              ]),
          subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$value $unit',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ]),
        ),
      ),
    );
  }
}
