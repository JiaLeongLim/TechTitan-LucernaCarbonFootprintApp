import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Lucerna/cf_summary.dart';
import 'package:Lucerna/chat.dart';
import 'package:Lucerna/dashboard.dart';
import 'package:Lucerna/lamp_stat.dart';
import 'package:Lucerna/main.dart';
import 'package:Lucerna/carbon_footprint.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'API_KEY_Config.dart';


class energyRecord extends StatefulWidget {
  @override
  _EnergyRecordState createState() => _EnergyRecordState();
}

class _EnergyRecordState extends State<energyRecord> {
  final _formKey = GlobalKey<FormState>(); // Key to manage form state
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _energyUsedController = TextEditingController();

// Method to calculate carbon footprint based on energy used
  Future<String> calculateCarbonFootprintFromEnergy(String energyUsed) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: ApiKeyConfig.geminiApiKey,
    );

    final prompt = '''
      Calculate the carbon footprint for using $energyUsed kWh of energy.
      Only provide the estimate result in kg CO₂ without additional text.
    ''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final carbonFootprintText = response.text ?? "0";

      print("Gemini API Response: $carbonFootprintText");

      // Extract numeric value
      final RegExp regex = RegExp(r'(\d+(\.\d+)?)');
      final match = regex.firstMatch(carbonFootprintText);
      return match?.group(0) ?? "0"; // Return numeric value or default to "0"
    } catch (e) {
      return "Error calculating footprint";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(173, 191, 127, 1),
        bottomNavigationBar: _buildBottomNavigationBar(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Add Energy Record',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 50),
                            _buildTextField(_titleController, 'Title'),
                            const SizedBox(height: 25),
                            _buildTextField(
                                _energyUsedController, 'Energy Used (in kWh)',
                                alphanumeric: true),
                            // const SizedBox(height: 20),
                            // _buildAttachmentSection(),
                            // const SizedBox(height: 40),,))],
                          ],
                        ),
                      ),
                    ),
                    _buildSubmitButton(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool alphanumeric = false}) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.labelSmall,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.5))),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // Validator to check for empty fields
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label cannot be empty. Please enter a valid value.';
          }
          if (alphanumeric) {
            // Check if the input is numeric
            final num? numericValue = num.tryParse(value);
            if (numericValue != null) {
              if (numericValue <= 0) {
                return '$label must be a positive value. Please enter either a text description or a valid numerical value.';
              }
            }
          }
          return null;
        });
  }

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        child: SizedBox(
          width: 175,
          child: ElevatedButton(
              onPressed: () async {
                // Validate the form
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, navigate to the next page
                  // Get input values
                  String title = _titleController.text;
                  String energyUsed = _energyUsedController.text;

                  /*
                Gemini API call here!!
                Pass the carbon footprint and suggestion to CFSummaryPage constructor
                */
                String carbonFootprint = await calculateCarbonFootprintFromEnergy(energyUsed);

                  // Navigate to the new page with the inputs
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CFSummaryPage(
                                title: title,
                                category: 'Energy',
                                carbon_footprint: carbonFootprint,
                                suggestion: '',
                                vehicleType: null,
                                distance: null,
                                energyUsed: energyUsed,
                              )));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5.0),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.ptSansCaption(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
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
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ecolight_stat()),
                );
              }),
          IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarbonFootprintTracker()));
              }),
          IconButton(
              icon: Image.asset('assets/chat-w.png'),
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
