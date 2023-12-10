// services.dart
part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(
      Uri.https(Const.baseUrl, "/starter/province"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
    );

    var job = json.decode(response.body);
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    return result;
  }

  static Future<List<City>> getCity(String provId) async {
    var response = await http.get(
      Uri.https(Const.baseUrl, "/starter/city"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
    );

    var job = json.decode(response.body);
    List<City> result = [];
    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCities = [];
    for (var c in result) {
      if (c.provinceId == provId) {
        selectedCities.add(c);
      }
    }

    return selectedCities;
  }

  // // services.dart
  // static Future<List<String>> getCouriers() async {
  //   var response = await http.get(
  //     Uri.https(Const.baseUrl, "/starter/couriers"), // Update the endpoint
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'key': Const.apiKey,
  //     },
  //   );

  //   var job = json.decode(response.body);
  //   List<String> result = [];

  //   if (response.statusCode == 200) {
  //     result = (job['rajaongkir']['results'] as List)
  //         .map((e) => e['code'].toString()) // Adjust based on your API response
  //         .toList();
  //   }
  //   return result;
  // }

  static Future<List<Cost>> getCosts({
    required String origin,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    var response = await http.post(
      Uri.parse('${Const.baseUrl}/starter/cost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
      body: jsonEncode({
        'origin': origin,
        'destination': destination,
        'weight': weight,
        'courier': courier,
      }),
    );

    if (response.statusCode == 200) {
      var job = json.decode(response.body);
      List<Cost> result = (job['rajaongkir']['results'][0]['costs'] as List)
          .map((e) => Cost.fromJson(e))
          .toList();
      return result;
    } else {
      throw Exception('Failed to get shipping costs');
    }
  }
}
