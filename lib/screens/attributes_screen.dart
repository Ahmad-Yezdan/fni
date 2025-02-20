import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/colors.dart';
import 'package:fni/common/constants/contants.dart';
import 'package:fni/common/utils.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  final TextEditingController _attributesController = TextEditingController();

  // Function to handle the Next button press
  void _validateAttributes(String? value) {
    if (value == null || value.isEmpty) {
      showSnackBar(context, 'Please enter the attributes.');
      return;
    }
    value = value.trim();

    if (value.startsWith(',') || value.endsWith(',')) {
      showSnackBar(context, 'Attributes cannot start or end with a comma.');
      return;
    }

    final attributes = value.split(',');
    final reservedKeywords = {
      'SELECT',
      'FROM',
      'WHERE',
      'INSERT',
      'UPDATE',
      'DELETE'
    };

    // Check for uniqueness
    if (attributes.toSet().length != attributes.length) {
      ///TODO: select one error message
      // showSnackBar(context, 'Attribute names must be unique.');
      showSnackBar(context, 'Duplicate attribute names are not allowed.');
      return;
    }

    for (var attribute in attributes) {
      if (attribute.isEmpty) {
        ///TODO: select one error message
        showSnackBar(context, 'Attributes cannot be empty between commas.');
        // showSnackBar(context, 'Empty attributes are not allowed.');
        return;
      }

      // Regex validation
      if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]*$').hasMatch(attribute)) {
        showSnackBar(context,
            'Invalid attribute name: $attribute. Attribute names must start with a letter and can only contain letters, numbers, or underscores.');
        return;
      }

      // Reserved keyword check
      if (reservedKeywords.contains(attribute.toUpperCase())) {
        showSnackBar(context,
            'Attribute name "$attribute" is a reserved keyword and cannot be used.');
        return;
      }

      // Length restriction
      if (attribute.length > 64) {
        showSnackBar(context,
            'Attribute name "$attribute" exceeds the maximum length of 64 characters.');
        return;
      }
    }

    // final _attributes =
    //     _attributesController.text.split(',').map((e) => e.trim()).toList();
    // showSnackBar(context, attributes.toString());
    // //Navigate to next screen with the attributes passed
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         FunctionalDependenciesScreen(attributes: _attributes),
    //   ),
    // );
  }

  // Slider values for depth, intensity, and surface intensity
  double _depth = -4; // Default depth set to a middle value between -20 and 20
  double _intensity = 1;
  double _surfaceIntensity = 0;

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    var textTheme = Theme.of(context).textTheme;
    var bgColor = Colors.white;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: sizeOf.height * 0.1,
                ),
                Center(
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 6,
                      intensity: 1,
                      surfaceIntensity: 0,
                      color: MyColors.scaffoldBackground,
                      boxShape: Constants.boxShape,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/fni.png',
                        width: sizeOf.width * 0.6,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: sizeOf.height * 0.07),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Attributes",
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // Neumorphic TextFormField
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: -4,
                    intensity: 1,
                    surfaceIntensity: 0,
                    color: MyColors.scaffoldBackground,
                    boxShape: Constants.boxShape,
                  ),
                  child: TextField(
                    controller: _attributesController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      hintText: 'e.g., A, B, A_B, X_Y',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                    minLines: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(
                          r'[a-zA-Z0-9_,]',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Neumorphic Next Button
                NeumorphicButton(
                  onPressed: () {
                    _validateAttributes(_attributesController.text);
                  },
                  style: NeumorphicStyle(
                    depth: 6,
                    intensity: 1,
                    surfaceIntensity: 0,
                    color: MyColors.scaffoldBackground,
                    boxShape: Constants.boxShape,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'Next',
                      style: textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
