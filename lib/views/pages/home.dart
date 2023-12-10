// ! it's work !
part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Province> provinceData = [];
  bool isLoadingOriginProvinces = false;
  bool isLoadingOriginCities = false;
  bool isLoadingDestinationProvinces = false;
  bool isLoadingDestinationCities = false;

  Province? selectedOriginProvince;
  City? selectedOriginCity;
  List<City> originCityData = [];

  Province? selectedDestinationProvince;
  City? selectedDestinationCity;
  List<City> destinationCityData = [];

  String? selectedCourier;
  int weight = 0;
  List<Cost> shippingCosts = [];

  // String? selectedCourier;
  List<String> courierData = [];

  Future<void> getProvinces(bool isOrigin) async {
    setState(() {
      if (isOrigin) {
        isLoadingOriginProvinces = true;
      } else {
        isLoadingDestinationProvinces = true;
      }
    });

    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value;
        if (isOrigin) {
          isLoadingOriginProvinces = false;
        } else {
          isLoadingDestinationProvinces = false;
        }
      });
    });
  }

  Future<void> getCities(String provId, bool isOrigin) async {
    setState(() {
      if (isOrigin) {
        isLoadingOriginCities = true;
      } else {
        isLoadingDestinationCities = true;
      }
    });

    var cities = await MasterDataService.getCity(provId);
    setState(() {
      if (isOrigin) {
        originCityData = cities;
        isLoadingOriginCities = false;
      } else {
        destinationCityData = cities;
        isLoadingDestinationCities = false;
      }
    });
  }

  // Future<void> getCouriers() async {
  //   setState(() {
  //     isLoadingOriginCities = true;
  //   });

  //   var couriers = await MasterDataService.getCouriers();
  //   setState(() {
  //     courierData = couriers;
  //     isLoadingOriginCities = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getProvinces(true);
    getProvinces(false);

    selectedOriginProvince = provinceData.isNotEmpty ? provinceData[0] : null;
    getCities(selectedOriginProvince?.provinceId ?? "", true);

    selectedDestinationProvince =
        provinceData.isNotEmpty ? provinceData[0] : null;
    getCities(selectedDestinationProvince?.provinceId ?? "", false);

    // getCouriers(); // Tambahkan ini untuk memuat data courier saat inisialisasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [],
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Text("Origin"),
                      Container(
                        width: 240,
                        child: DropdownButton<Province>(
                          isExpanded: true,
                          value: selectedOriginProvince,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 4,
                          style: TextStyle(color: Colors.black),
                          hint: selectedOriginProvince == null
                              ? Text('Pilih provinsi')
                              : Text(selectedOriginProvince!.province!),
                          items: provinceData.map((Province value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value.province!),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedOriginProvince = newValue;
                              selectedOriginCity = null;
                              getCities(
                                  selectedOriginProvince?.provinceId ?? "",
                                  true);
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 240,
                        child: Stack(
                          children: [
                            DropdownButton<City>(
                              isExpanded: true,
                              value: selectedOriginCity,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 4,
                              style: TextStyle(color: Colors.black),
                              hint: selectedOriginCity == null
                                  ? Text('Pilih kota')
                                  : Text(selectedOriginCity!.cityName!),
                              items: originCityData.map((City value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.cityName!),
                                );
                              }).toList(),
                              onChanged: isLoadingOriginCities
                                  ? null
                                  : (newValue) {
                                      setState(() {
                                        selectedOriginCity = newValue;
                                      });
                                    },
                            ),
                            if (isLoadingOriginCities)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Destination"),
                      Container(
                        width: 240,
                        child: DropdownButton<Province>(
                          isExpanded: true,
                          value: selectedDestinationProvince,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 4,
                          style: TextStyle(color: Colors.black),
                          hint: selectedDestinationProvince == null
                              ? Text('Pilih provinsi')
                              : Text(selectedDestinationProvince!.province!),
                          items: provinceData.map((Province value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value.province!),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDestinationProvince = newValue;
                              selectedDestinationCity = null;
                              getCities(
                                  selectedDestinationProvince?.provinceId ?? "",
                                  false);
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 240,
                        child: Stack(
                          children: [
                            DropdownButton<City>(
                              isExpanded: true,
                              value: selectedDestinationCity,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 4,
                              style: TextStyle(color: Colors.black),
                              hint: selectedDestinationCity == null
                                  ? Text('Pilih kota')
                                  : Text(selectedDestinationCity!.cityName!),
                              items: destinationCityData.map((City value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.cityName!),
                                );
                              }).toList(),
                              onChanged: isLoadingDestinationCities
                                  ? null
                                  : (newValue) {
                                      setState(() {
                                        selectedDestinationCity = newValue;
                                      });
                                    },
                            ),
                            if (isLoadingDestinationCities)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Weight (gram)"),
                      Container(
                        width: 240,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              weight = int.parse(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Courier"),
                      Container(
                        width: 240,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedCourier,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 4,
                          style: TextStyle(color: Colors.black),
                          hint: selectedCourier == null
                              ? Text('Select courier')
                              : Text(selectedCourier!),
                          items: courierData.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCourier = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          // Call your API to get shipping costs here
                          // Update the endpoint and parameters based on your actual API
                          var costs = await MasterDataService.getCosts(
                            origin: selectedOriginCity?.cityId ?? "",
                            destination: selectedDestinationCity?.cityId ?? "",
                            weight: weight,
                            courier: selectedCourier ?? "",
                          );

                          setState(() {
                            shippingCosts = costs;
                          });
                        },
                        child: Text("Calculate Shipping Cost"),
                      ),
                      // Display the shipping costs
                      Column(
                        children: shippingCosts.map((cost) {
                          return Card(
                            child: ListTile(
                              title: Text("Service: ${cost.service}"),
                              subtitle:
                                  Text("Cost: ${cost.value}, ETD: ${cost.etd}"),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
