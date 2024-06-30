// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'meal.dart';
import 'package:http/http.dart' as http;
import 'background_painter.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const CustomAppBar(
      title: 'Dish Dash',
    ),
    body: Stack(
      children: [
        CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: BackgroundPainter(),
        ),
        Positioned.fill(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 60),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double offset = 300 * (1 - _animation.value);
                  double opacity = _animation.value;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Opacity(
                      opacity: opacity,
                      child: Center(
                        child: Image.asset(
                          'assets/images/Chef.png',
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double offset = 300 * (1 - _animation.value);
                  double opacity = _animation.value;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Opacity(
                      opacity: opacity,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: 205,
                              height: 62,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color.fromARGB(255, 184, 60, 206),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                child: const Text('Favourites'),
                                onPressed: () {
                                  // Navigate to Favourites Screen
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 205,
                              height: 62,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color.fromARGB(255, 184, 60, 206),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                child: const Text('All Food'),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/categories',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: 205,
                              height: 62,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color.fromARGB(255, 184, 60, 206),
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                child: const Text('Random Meal'),
                                onPressed: () async {
                                  Meal randomMeal = await getRandomMeal();
                                  Navigator.pushNamed(
                                    context,
                                    '/meal_card',
                                    arguments: {'mealId': int.parse(randomMeal.id)},
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    ),
  );
}

  Future<Meal> getRandomMeal() async {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var meal = jsonResponse['meals'][0];
      return Meal.fromJson(meal);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}

