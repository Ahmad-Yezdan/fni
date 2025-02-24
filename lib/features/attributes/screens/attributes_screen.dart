import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:fni/common/theme/colors.dart';
import 'package:fni/common/constants/neumorphic_style.dart';
import 'package:fni/common/widgets/neum_logo.dart';
import 'package:fni/features/attributes/helper_functions/attribute_screen_helper.dart';
import 'package:fni/features/functional_dependencies/screens/functional_dependencies_screen.dart';
import 'package:get/get.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  final TextEditingController _attributesController = TextEditingController();

  void navigateToFunctionalDependenciesScreen(List<String> attributes) {
    Get.to(
      FunctionalDependenciesScreen(attributes: List.from(attributes)..sort()),
      transition: Transition.rightToLeft,
      curve: Curves.linear,
    );
  }

  void nextButtonOnTap() {
    List<String>? attributes =
        validateAttributes(context, _attributesController.text);
    if (attributes != null) {
      navigateToFunctionalDependenciesScreen(attributes);
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attributes"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const NeumLogo(
                textColor: MyColors.primary,
                bgColor: MyColors.scaffoldBackground,
              ),
              const SizedBox(height: 35),
              // Neumorphic TextFormField
              Neumorphic(
                style: NeumStyle.rect,
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
              const SizedBox(height: 35),
              // Neumorphic Next Button
              NeumorphicButton(
                onPressed: nextButtonOnTap,
                style: NeumStyle.rect.copyWith(depth: 6),
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
    );
  }
}
