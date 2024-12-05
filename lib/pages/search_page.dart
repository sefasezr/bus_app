import 'package:bus_reservation_flutter_starter/datasource/temp_db.dart';
import 'package:bus_reservation_flutter_starter/utils/constants.dart';
import 'package:bus_reservation_flutter_starter/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? fromCity, toCity;
  DateTime? departureDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            children: [
              DropdownButtonFormField<String>(
                  value: fromCity,
                  hint: Text('From'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emptyFieldErrMessage;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.white),
                  ),
                  isExpanded: true,
                  items: cities
                      .map(
                        (city) => DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      fromCity = value;
                    });
                  }),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: toCity,
                hint: Text('To'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emptyFieldErrMessage;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorStyle: const TextStyle(color: Colors.white),
                ),
                isExpanded: true,
                items: cities
                    .map(
                      (city) => DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    toCity = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _selectDate,
                      child: const Text(
                        'Select Departure Date',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    Text(departureDate == null
                        ? 'No Date Chosen'
                        : getFormattedDate(departureDate!)),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _search,
                    child: Text('SEARCH'),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
          const Duration(days: 7),
        ));
    if (selectedDate != null) {
      setState(() {
        departureDate = selectedDate;
      });
    }
  }

  void _search() {
    if (departureDate == null) {
      _showMsg(context, emptyDateTimeErrMessage);
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        final route = TempDB.tableRoute.firstWhere((element) =>
            element.cityFrom == fromCity && element.cityTo == toCity);
        _showMsg(context, route.routeName);
      } on StateError catch (error) {
        _showMsg(context, 'No route found');
      }
    }
  }
}

void _showMsg(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
