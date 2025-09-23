import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/bloc/weather_bloc_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    _loadWeather(); // 👈 Start fetching as soon as widget loads
  }

  Future<void> _loadWeather() async {
    try {
      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Send event to Bloc
      context.read<WeatherBlocBloc>().add(FetchWeather(position));
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Widget getWeatherIcon(int hafi) {
    // Example logic, you may want to expand this for more cases
    if (hafi > 200 && hafi <= 300) {
      return Image.asset('assets/images/3.png');
    } else if (hafi > 300 && hafi <= 400) {
      return Image.asset('assets/images/4.png');
    } else if (hafi > 400 && hafi <= 500) {
      return Image.asset('assets/images/4.png');
    } else if (hafi > 500 && hafi <= 600) {
      return Image.asset('assets/images/6.png');
    } else if (hafi > 600 && hafi <= 700) {
      return Image.asset('assets/images/7.png');
    } else if (hafi == 800) {
      return Image.asset('assets/images/1.png');
    } else if (hafi >= 801 && hafi <= 804) {
      return Image.asset('assets/images/2.png');
    } else {
      return Image.asset('assets/images/1.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          //
          statusBarBrightness: Brightness.dark,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Purple circle right side
              Align(
                alignment: const Alignment(1.2, -0.3), // smaller value → inside
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),
              // Purple circle left side
              Align(
                alignment: const Alignment(-1.2, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),
              // Amber circle center
              Align(
                alignment: const Alignment(0, -0.8),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.amber[700],
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
              // Foreground text
              BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                builder: (context, state) {
                  print("👉 Current WeatherBloc state: $state");

                  if (state is WeatherBlocLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (state is WeatherBlocFailure) {
                    return Center(
                      child: Text(
                        "❌ Failed to fetch weather data",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is WeatherBlocSuccess) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              '📍 ${state.weather.areaName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Good Morning',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Center(
                                child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: getWeatherIcon(
                                    state.weather.weatherConditionCode!,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                '${state.weather.temperature!.celsius!.round()} C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                state.weather.weatherMain!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                DateFormat(
                                  'EEEE, dd -',
                                ).add_jm().format(state.weather.date!),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/11.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          'Sunrise',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          DateFormat().add_jm().format(
                                            state.weather.sunrise!,
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/12.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          'Sunset',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          DateFormat().add_jm().format(
                                            state.weather.sunset!,
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/13.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          'Temp Max',

                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          " ${state.weather.tempMax!.celsius!.round().toString()}'C",

                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Divider(color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/14.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          'Temp min',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          " ${state.weather.tempMin!.celsius!.round().toString()}'C",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Text(
                    'Correct your Data',
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
