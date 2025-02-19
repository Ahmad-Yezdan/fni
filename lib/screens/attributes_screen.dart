import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fni/screens/functional_dependencies_screen.dart';
import 'package:fni/common/utils.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _attributesController = TextEditingController();

  // When Next is pressed, navigate to Functional Dependencies Screen
  void _goToFunctionalDependenciesScreen() {
    if (_formKey.currentState!.validate()) {
      final attributes =
          _attributesController.text.split(',').map((e) => e.trim()).toList();
      // showSnackBar(context, attributes.toString());
      // Navigate to next screen with the attributes passed
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         FunctionalDependenciesScreen(attributes: attributes),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Attributes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _attributesController,
                decoration: const InputDecoration(
                  labelText: 'Attributes (comma separated)',
                  hintText: 'e.g., A, B, A_B, X_Y',
                ),
                maxLines: 5,
                minLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    showSnackBar(context, 'Please enter the attributes');
                    return '';
                  }

                  // Trim the input to remove any leading/trailing spaces
                  value = value.trim();

                  // Check for leading or trailing commas
                  if (value.startsWith(',') || value.endsWith(',')) {
                    showSnackBar(
                        context, 'Attributes cannot start or end with a comma');
                    return '';
                  }

                  // Split the input by commas to get the individual attributes
                  final attributes = value.split(',');

                  // Check for multiple consecutive commas
                  for (int i = 0; i < attributes.length - 1; i++) {
                    if (attributes[i].trim().isEmpty &&
                        attributes[i + 1].trim().isEmpty) {
                      showSnackBar(
                          context, 'Attributes cannot be empty between commas');
                      return '';
                    }
                  }

                  // Validate each attribute according to Codd's rules
                  for (var attribute in attributes) {
                    attribute =
                        attribute.trim(); // Trim any surrounding whitespace
                    if (attribute.isEmpty) {
                      return 'Attribute cannot be empty';
                    }
                    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]*$')
                        .hasMatch(attribute)) {
                      showSnackBar(context,
                          'Invalid attribute name: $attribute. Only letters, digits, and underscores are allowed. No leading or trailing underscores.');
                      return '';
                    }
                  }

                  return null;
                },
                inputFormatters: [
                  // Allow only letters, digits, underscores, and commas
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_,]')),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _goToFunctionalDependenciesScreen,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






