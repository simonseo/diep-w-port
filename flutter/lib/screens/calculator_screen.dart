import 'package:flutter/material.dart';
import '../widgets/measurement_input.dart';
import '../widgets/info_dialog.dart';
import '../widgets/inline_bmi_calculator.dart';
import '../services/calculation_history_service.dart';

enum CalculationMethod { pinch, ct }

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Current calculation method
  CalculationMethod _selectedMethod = CalculationMethod.ct;
  
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

  // Formula card expansion state
  bool _isFormulaExpanded = false;

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

      double flapWeight;
      String methodName;

      if (_selectedMethod == CalculationMethod.pinch) {
        // DIEP-W Pinch formula
        // Weight = -1308 + 24.57*BMI + 6.8*(R+L)/2 + 7.89*I + 20.51*H + 32.55*W
        flapWeight = -1308 + 
            (24.57 * bmi) + 
            (6.8 * (rmm + lmm) / 2) + 
            (7.89 * imm) + 
            (20.51 * hcm) + 
            (32.55 * wcm);
        methodName = 'Pinch';
      } else {
        // DIEP-W CT formula
        // Weight = -435 + 11.61*BMI - 23.23*(R+L)/2 + 8.74*I + 37.72*H - 4.63*W + 1.0884*(R+L)/2*W
        final avgRL = (rmm + lmm) / 2;
        flapWeight = -435 + 
            (11.61 * bmi) - 
            (23.23 * avgRL) + 
            (8.74 * imm) + 
            (37.72 * hcm) - 
            (4.63 * wcm) + 
            (1.0884 * avgRL * wcm);
        methodName = 'CT';
      }

      setState(() {
        _flapController.text = flapWeight.toStringAsFixed(1);
      });

      // Save to history
      try {
        final historyService = CalculationHistoryService();
        await historyService.addCalculation(CalculationResult(
          method: methodName,
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calculation completed and saved to history'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // History save failed, but calculation succeeded
        if (mounted) {
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

  void _onMethodChanged(CalculationMethod? method) {
    if (method != null && method != _selectedMethod) {
      setState(() {
        _selectedMethod = method;
        _flapController.clear(); // Clear result when switching methods
      });
      
      // Auto-recalculate if all fields are filled
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        _calculate();
      }
    }
  }

  String get _diagramDescription {
    if (_selectedMethod == CalculationMethod.pinch) {
      return 'Measure flap thickness using pinch technique at three paraumbilical sites: 5 cm right (R), left (L), and inferior (I) from umbilicus.';
    } else {
      return 'Measure flap thickness using CT angiography at three paraumbilical sites: 5 cm right (R), left (L), and inferior (I) from umbilicus.';
    }
  }

  String get _formulaText {
    if (_selectedMethod == CalculationMethod.pinch) {
      return 'Weight = -1308 + 24.57×BMI + 6.8×(R+L)/2 + 7.89×I + 20.51×H + 32.55×W';
    } else {
      return 'Weight = -435 + 11.61×BMI - 23.23×(R+L)/2 + 8.74×I + 37.72×H - 4.63×W + 1.0884×(R+L)/2×W';
    }
  }

  String _getImagePath(String field) {
    final methodSuffix = _selectedMethod == CalculationMethod.pinch ? 'pinch' : 'CT';
    return 'assets/images/${field}_$methodSuffix.png';
  }

  String _getFieldDescription(String field) {
    if (_selectedMethod == CalculationMethod.pinch) {
      switch (field) {
        case 'I':
          return 'Inferior para-umbilical flap thickness measured by pinch test. Flap thickness is measured using skin fold caliper at 5 cm inferior from the umbilicus and it is divided by 2.';
        case 'L':
          return 'Left para-umbilical flap thickness measured by pinch test. Flap thickness is measured using skin fold caliper at 5 cm lateral (left) from the umbilicus and it is divided by 2.';
        case 'R':
          return 'Right para-umbilical flap thickness measured by pinch test. Flap thickness is measured using skin fold caliper at 5 cm lateral (right) from the umbilicus and it is divided by 2.';
        default:
          return '';
      }
    } else {
      switch (field) {
        case 'I':
          return 'Inferior para-umbilical flap thickness measured on CT angiography at 5 cm inferior from the umbilicus.';
        case 'L':
          return 'Left para-umbilical flap thickness measured on CT angiography at 5 cm lateral (left) from the umbilicus.';
        case 'R':
          return 'Right para-umbilical flap thickness measured on CT angiography at 5 cm lateral (right) from the umbilicus.';
        default:
          return '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIEP-W Calculator'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Diagram Card (full width on mobile)
              _buildDiagramCard(),
              
              // 2. Method Toggle
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildMethodToggle(),
              ),
              
              // 3. Formula Card (collapsible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildFormulaCard(),
              ),
              
              // 4-7. Input sections
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 4. BMI Section
                    _buildBMISection(),
                    const SizedBox(height: 16),
                    
                    // 5. Tissue Thickness Section
                    _buildTissueThicknessSection(),
                    const SizedBox(height: 16),
                    
                    // 6. Flap Dimensions Section
                    _buildFlapDimensionsSection(),
                    const SizedBox(height: 16),
                    
                    // 7. Result Section
                    _buildResultSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagramCard() {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/figure_new.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedMethod == CalculationMethod.pinch 
                              ? Icons.person 
                              : Icons.medical_services,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const Text(
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
            Text(
              _selectedMethod == CalculationMethod.pinch 
                ? 'Pinch Measurement Method' 
                : 'CT Measurement Method',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _diagramDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodToggle() {
    return SegmentedButton<CalculationMethod>(
      segments: const [
        ButtonSegment<CalculationMethod>(
          value: CalculationMethod.pinch,
          label: Text('Pinch Test'),
          icon: Icon(Icons.precision_manufacturing),
        ),
        ButtonSegment<CalculationMethod>(
          value: CalculationMethod.ct,
          label: Text('CT Scan'),
          icon: Icon(Icons.photo),
        ),
      ],
      selected: {_selectedMethod},
      onSelectionChanged: (Set<CalculationMethod> newSelection) {
        _onMethodChanged(newSelection.first);
      },
    );
  }

  Widget _buildFormulaCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.functions, color: Color(0xFF4A90E2)),
            title: const Text(
              'Formula',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
              icon: Icon(_isFormulaExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isFormulaExpanded = !_isFormulaExpanded;
                });
              },
            ),
            onTap: () {
              setState(() {
                _isFormulaExpanded = !_isFormulaExpanded;
              });
            },
          ),
          if (_isFormulaExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    _formulaText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBMISection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Body Mass Index',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            InlineBMICalculator(
              onBMICalculated: (bmi) {
                setState(() {
                  _bmiController.text = bmi.toStringAsFixed(1);
                });
              },
              nextFocusNode: _immFocus,
            ),
            const SizedBox(height: 16),
            MeasurementInput(
              controller: _bmiController,
              focusNode: _bmiFocus,
              label: 'BMI',
              hint: 'BMI',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onFieldSubmitted: () => _immFocus.requestFocus(),
              onInfoTap: () => showInfoDialog(
                context,
                'Body Mass Index (BMI)',
                'BMI = weight (kg) / height² (m²)\n\nUse the BMI calculator above or enter directly.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTissueThicknessSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Para-umbilical Tissue Thickness',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Mobile: I full width, then L | R
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      MeasurementInput(
                        controller: _immController,
                        focusNode: _immFocus,
                        label: 'I. mm',
                        hint: 'Inferior',
                        onFieldSubmitted: () => _lmmFocus.requestFocus(),
                        onInfoTap: () => showInfoDialog(
                          context,
                          'Inferior Measurement (I mm)',
                          _getFieldDescription('I'),
                          imagePath: _getImagePath('I'),
                        ),
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
                              onFieldSubmitted: () => _rmmFocus.requestFocus(),
                              onInfoTap: () => showInfoDialog(
                                context,
                                'Left Measurement (L mm)',
                                _getFieldDescription('L'),
                                imagePath: _getImagePath('L'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: MeasurementInput(
                              controller: _rmmController,
                              focusNode: _rmmFocus,
                              label: 'R. mm',
                              hint: 'Right',
                              onFieldSubmitted: () => _hcmFocus.requestFocus(),
                              onInfoTap: () => showInfoDialog(
                                context,
                                'Right Measurement (R mm)',
                                _getFieldDescription('R'),
                                imagePath: _getImagePath('R'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                
                // Desktop/Tablet: I | L | R in one row
                return Row(
                  children: [
                    Expanded(
                      child: MeasurementInput(
                        controller: _immController,
                        focusNode: _immFocus,
                        label: 'I. mm',
                        hint: 'Inferior',
                        onFieldSubmitted: () => _lmmFocus.requestFocus(),
                        onInfoTap: () => showInfoDialog(
                          context,
                          'Inferior Measurement (I mm)',
                          _getFieldDescription('I'),
                          imagePath: _getImagePath('I'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MeasurementInput(
                        controller: _lmmController,
                        focusNode: _lmmFocus,
                        label: 'L. mm',
                        hint: 'Left',
                        onFieldSubmitted: () => _rmmFocus.requestFocus(),
                        onInfoTap: () => showInfoDialog(
                          context,
                          'Left Measurement (L mm)',
                          _getFieldDescription('L'),
                          imagePath: _getImagePath('L'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MeasurementInput(
                        controller: _rmmController,
                        focusNode: _rmmFocus,
                        label: 'R. mm',
                        hint: 'Right',
                        onFieldSubmitted: () => _hcmFocus.requestFocus(),
                        onInfoTap: () => showInfoDialog(
                          context,
                          'Right Measurement (R mm)',
                          _getFieldDescription('R'),
                          imagePath: _getImagePath('R'),
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
    );
  }

  Widget _buildFlapDimensionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Planned Flap Dimensions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: MeasurementInput(
                    controller: _wcmController,
                    focusNode: _wcmFocus,
                    label: 'W. cm',
                    hint: 'Width',
                    onFieldSubmitted: () => _hcmFocus.requestFocus(),
                    onInfoTap: () => showInfoDialog(
                      context,
                      'Flap Width (W)',
                      'Horizontal width of the planned flap in centimeters.',
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
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: _calculate,
                    onInfoTap: () => showInfoDialog(
                      context,
                      'Flap Height (H)',
                      'Vertical height of the planned flap in centimeters.',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Estimated Weight',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
    );
  }
}
