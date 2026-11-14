import 'package:flutter/material.dart';

import '../../../translation/presentation/pages/language_models_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const LanguageModelsPage(initialSetup: true);
}
