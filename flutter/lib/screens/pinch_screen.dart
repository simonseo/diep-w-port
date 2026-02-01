import 'package:flutter/material.dart';
import '../widgets/measurement_input.dart';
import '../widgets/info_dialog.dart';
import '../widgets/inline_bmi_calculator.dart';
import '../services/calculation_history_service.dart';

class PinchScreen extends StatefulWidget {
  const PinchScreen({super.key});

  @override
  State<PinchScreen> createState() => _PinchScreenState();
}

class _PinchScreenState extends State<PinchScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for input fields
  final TextEditingController _rmmController = TextEditingController();
  final TextEditingController _lmmController = TextEditingController();
  final TextEditingController _immController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _hcmController = TextEditingController();
  final TextEditingController _wcmController = TextEditingController();
  final TextEditingController _flapController = TextEditingController();

  // Focus nodes for keyboard navigation
  final FocusNode _rmmFocus = FocusNode();
  final FocusNode _lmmFocus = FocusNode();
  final FocusNode _immFocus = FocusNode();
  final FocusNode _bmiFocus = FocusNode();
  final FocusNode _hcmFocus = FocusNode();
  final FocusNode _wcmFocus = FocusNode();

  @override
  void dispose() {
    _rmmController.dispose();
    _lmmController.dispose();
    _immController.dispose();
    _bmiController.dispose();
    _hcmController.dispose();
    _wcmController.dispose();
    _flapController.dispose();
    _rmmFocus.dispose();
    _lmmFocus.dispose();
    _immFocus.dispose();
    _bmiFocus.dispose();
    _hcmFocus.dispose();
    _wcmFocus.dispose();
    super.dispose();
  }

  void _calculate() async {
    if (_formKey.currentState!.validate()) {
      final rmm = double.tryParse(_rmmController.text) ?? 0;
      final lmm = double.tryParse(_lmmController.text) ?? 0;
      final imm = double.tryParse(_immController.text) ?? 0;
      final bmi = double.tryParse(_bmiController.text) ?? 0;
      final hcm = double.tryParse(_hcmController.text) ?? 0;
      final wcm = double.tryParse(_wcmController.text) ?? 0;

      // DIEP-W Pinch formula from the paper
      // Weight = -1308 + 24.57*BMI + 6.8*(R+L)/2 + 7.89*I + 20.51*H + 32.55*W
      final flapWeight = -1308 + 
          (24.57 * bmi) + 
          (6.8 * (rmm + lmm) / 2) + 
          (7.89 * imm) + 
          (20.51 * hcm) + 
          (32.55 * wcm);

      setState(() {
        _flapController.text = flapWeight.toStringAsFixed(1);
      });

      // Save to history
      try {
        final historyService = CalculationHistoryService();
        await historyService.addCalculation(CalculationResult(
          method: 'Pinch',
          result: flapWeight,
          timestamp: DateTime.now(),
          inputs: {
            'R (mm)': rmm,
            'L (mm)': lmm,
            'I (mm)': imm,
            'BMI': bmi,
            'H (cm)': hcm,
            'W (cm)': wcm,
          },
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calculation completed and saved to history'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // History save failed, but calculation succeeded
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calculation completed (history save failed: $e)'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _reset() {
    setState(() {
      _rmmController.clear();
      _lmmController.clear();
      _immController.clear();
      _bmiController.clear();
      _hcmController.clear();
      _wcmController.clear();
      _flapController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIEP-W: Pinch Method'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/figure_new.png',
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person, size: 80, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text(
                                        'Measurement Diagram',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Pinch Measurement Method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Measure flap thickness using pinch technique at three paraumbilical sites: 5 cm right (R), left (L), and inferior (I) from umbilicus.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InlineBMICalculator(
                  onBMICalculated: (bmi) {
                    setState(() {
                      _bmiController.text = bmi.toStringAsFixed(1);
                    });
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MeasurementInput(
                                controller: _rmmController,
                                focusNode: _rmmFocus,
                                label: 'R. mm',
                                hint: 'Right',
                                onFieldSubmitted: () => _bmiFocus.requestFocus(),
                                onInfoTap: () => showInfoDialog(
                                  context,
                                  'Right Measurement (R mm)',
                                  'Right para-umbilical flap thickness measured by pinch test. Flap thickness is measured using skin fold caliper at 5 cm lateral (right) from the umbilicus and it is divided by 2.',
                                  imagePath: 'assets/images/R_pinch.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: MeasurementInput(
                                controller: _bmiController,
                                focusNode: _bmiFocus,
                                label: 'BMI',
                                hint: 'BMI',
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onFieldSubmitted: () => _lmmFocus.requestFocus(),
                                onInfoTap: () => showInfoDialog(
                                  context,
                                  'Body Mass Index (BMI)',
                                  'BMI = weight (kg) / height² (m²)\n\nUse the inline calculator above.',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MeasurementInput(
                                controller: _lmmController,
                                focusNode: _lmmFocus,
                                label: 'L. mm',
                                hint: 'Left',
                                onFieldSubmitted: () => _hcmFocus.requestFocus(),
                                onInfoTap: () => showInfoDialog(
                                  context,
                                  'Left Measurement (L mm)',
                                  'Left para-umbilical flap thickness measured by pinch test. Flap thickness is measured using skin fold caliper at 5 cm lateral (left) from the umbilicus and it is divided by 2.',
                                  imagePath: 'assets/images/L_pinch.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: MeasurementInput(
                                controller: _hcmController,
                                focusNode: _hcmFocus,
                                label: 'H. cm',
                                hint: 'Height',
                                onFieldSubmitted: () => _immFocus.requestFocus(),
                                onInfoTap: () => showInfoDialog(
                                  context,
                                  'Flap Height (H)',
                                  'Vertical height of the planned flap in centimeters.',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MeasurementInput(
                                controller: _immController,
                                focusNode: _immFocus,
                                label: 'I. mm',
                                hint: 'Inferior',
                                onFieldSubmitted: () => _wcmFocus.requestFocus(),
                                onInfoTap: () => showInfoDialog(
                                  context,
                                  'Inferior Measurement (I mm)',
                                  'Inferior para-umbilical flap thickness measured by pinch test. Flap thickness is measured using skin fold caliper at 5 cm inferior from the umbilicus and it is divided by 2.',
                                  imagePath: 'assets/images/I_pinch.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: MeasurementInput(
                                controller: _wcmController,
                                focusNode: _wcmFocus,
                                label: 'W. cm',
                                hint: 'Width',
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: _calculate,
                                onInfoTap: () => showInfoDialog(
                                  context,
                                  'Flap Width (W)',
                                  'Horizontal width of the planned flap in centimeters.',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        MeasurementInput(
                          controller: _flapController,
                          label: 'Flap Weight (g)',
                          hint: 'Result',
                          readOnly: true,
                          icon: Icons.scale,
                        ),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Use icon-only button on narrow screens
                            final useIconOnly = constraints.maxWidth < 400;
                            
                            return Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton.icon(
                                    onPressed: _calculate,
                                    icon: const Icon(Icons.calculate),
                                    label: const Text('Calculate'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 1,
                                  child: useIconOnly
                                      ? ElevatedButton(
                                          onPressed: _reset,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[300],
                                            foregroundColor: Colors.black87,
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: const Icon(Icons.refresh),
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: _reset,
                                          icon: const Icon(Icons.refresh),
                                          label: const Text('Reset'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[300],
                                            foregroundColor: Colors.black87,
                                          ),
                                        ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Formula',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Weight = -1308 + 24.57×BMI + 6.8×(R+L)/2 + 7.89×I + 20.51×H + 32.55×W',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, fontFamily: 'monospace'),
                        ),
                      ],
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
