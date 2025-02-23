import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/theme/colors.dart';
import 'package:fni/common/constants/contants.dart';
import 'package:fni/common/utils.dart';
import 'package:fni/screens/functional_dependencies_screen.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  final TextEditingController _attributesController = TextEditingController();

  void _navigateToFunctionalDependenciesScreen(
      BuildContext context, List<String> attributes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FunctionalDependenciesScreen(attributes: attributes),
      ),
    );
  }

  void _validateAttributes(BuildContext context, String? value) {
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
        String attributeName = attribute.length >= 7
            ? '${attribute.substring(0, 7)}...'
            : attribute;
        showSnackBar(context,
            'Invalid attribute name: "$attributeName". Attribute names must start with a letter and can only contain letters, numbers, or underscores.');
        return;
      }

      //TODO: confirm for Sir whether to add or not add this check
      // Reserved keyword check
      // final reservedKeywords = {
      //   'SELECT',
      //   'FROM',
      //   'WHERE',
      //   'INSERT',
      //   'UPDATE',
      //   'DELETE'
      // };

      // if (reservedKeywords.contains(attribute.toUpperCase())) {
      //   showSnackBar(context,
      //       'Attribute name "$attribute" is a reserved keyword and cannot be used.');
      //   return;
      // }

      // Length restriction
      if (attribute.length > 64) {
        String attributeName = attribute.length >= 7
            ? '${attribute.substring(0, 7)}...'
            : attribute;
        showSnackBar(context,
            'Attribute name "$attributeName" exceeds the maximum length of 64 characters.');
        return;
      }
    }

    // final atrs =
    //     _attributesController.text.split(',').map((e) => e.trim()).toList();

    _navigateToFunctionalDependenciesScreen(context, attributes);
  }

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: sizeOf.height * 0.05,
                ),
                Center(
                  child: Neumorphic(
                    style: const NeumorphicStyle(
                      depth: 6,
                      intensity: 1,
                      surfaceIntensity: 0,
                      boxShape: NeumorphicBoxShape.circle(),
                      color: MyColors.scaffoldBackground,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        "fni",
                        style: TextStyle(
                            fontSize: 127,
                            fontFamily: "ArchivoBlack",
                            color: MyColors.primary),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: sizeOf.height * 0.04),
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
                    boxShape: Constants.rectBoxShape,
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
                    _validateAttributes(context, _attributesController.text);
                  },
                  style: NeumorphicStyle(
                    depth: 6,
                    intensity: 1,
                    surfaceIntensity: 0,
                    color: MyColors.scaffoldBackground,
                    boxShape: Constants.rectBoxShape,
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
