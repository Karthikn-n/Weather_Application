import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secerts.dart';
class WeatherScreen extends StatefulWidget{
  
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      String city = 'Srivilliputhur';
      final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openAPIKey'
      ),
    );
    final data = jsonDecode(res.body);

    if(data['cod'] != '200'){
      throw 'An unexpected error occurred';
    }
    return data;
      // 
    }
    catch (e){
        throw  e.toString();
    }
    
  }
@override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Weather App',
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      
        actions:  [
          IconButton(
          onPressed: (){
            setState(() {
              weather = getCurrentWeather();
            });  // local state management 
          },
          icon: const Icon(Icons.refresh_outlined, ),
          
          ),
        ],
      ),
      body: SingleChildScrollView(
        
        child: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(
                
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Internet Connection Is Required',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18.0,)
            )
            ),
    )
          ); 
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child:  CircularProgressIndicator.adaptive(),
                );
            }
            if(snapshot.hasError){
              return Center(
                child: Text(snapshot.hasError.toString()
                ),
              );
            }
            final data = snapshot.data!;
            // API Data's 
      
            final current = data['list'][0];
            final currentTemp = current ['main']['temp'] - 273.15 ;     
            final currentSky = current ['weather'][0]['main'];
            final pressure = current['main']['pressure'];
            final windSpeed = current['wind']['speed'];
            final humidity = current['main']['humidity'];
      
            return Padding(
            padding: const EdgeInsets.all(16.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
               SizedBox(
                width: double.infinity,
                 child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                           Text(
                            //°C
                            currentTemp.toStringAsFixed(2) +'°C',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,

                          ),
                          const SizedBox(height: 16),
                           Icon(currentSky == 'Clouds' || currentSky == 'Rain'
                           ? Icons.cloud
                            : Icons.sunny,
                          size: 74,
                          ),
                          const SizedBox(height: 8,),
                           Text(
                            currentSky,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                 ),
               ),
                const SizedBox(height: 20),
                // weather forecast widget Start
                const Text(
                  'Hourly Forecast',
                 style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                 ), 
                ),
                const SizedBox(height: 16),
          
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                   itemCount: 5,
                   itemBuilder: (context, index) {
                     final hourlyForecast = data['list'][index+1];
                     final hourlySky = data['list'][index+1]['weather'][0]['main'];
                     final time = DateTime.parse(hourlyForecast['dt_txt']);
                     final temp = hourlyForecast['main']['temp'] - 273.15;
                     return HourlyForcast(
                      time: DateFormat.j().format(time),
                      temp: temp.toStringAsFixed(2)+'°C',
                      icon: hourlySky == 'Clouds' || hourlySky == 'Rain' ?
                        Icons.cloud :
                        Icons.sunny,
                      );
                   },
                    ),
                ),
                // weeather Forecast widget ends
                const SizedBox(height: 20),
                // additional information widget start
                const Text(
                  'Additional Information',
                 style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                 ), 
                ),
                const SizedBox(height: 20),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      lable: 'Humidity',
                      value: humidity.toString(),
                      ),
                     AdditionalInfoItem(
                      icon: Icons.air,
                      lable: 'Wind Speed',
                      value: windSpeed.toString() + 'mph'.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        lable: 'Pressure',
                        value: pressure.toString(),
                
                      ),
                  ],
                ),
                // additional information widget start
              ],
            ),
          );
          },
        ),
      ),
    );
  }
}
