import 'package:flutter/material.dart';

class InlineBMICalculator extends StatefulWidget {
  final Function(double) onBMICalculated;
  final FocusNode? nextFocusNode;
  
  const InlineBMICalculator({
    super.key,
    required this.onBMICalculated,
    this.nextFocusNode,
  });

  @override
  State<InlineBMICalculator> createState() => _InlineBMICalculatorState();
}

class _InlineBMICalculatorState extends State<InlineBMICalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final FocusNode _weightFocus = FocusNode();
  final FocusNode _heightFocus = FocusNode();
  bool _isExpanded = true;
  double? _calculatedBMI;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _weightFocus.dispose();
    _heightFocus.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight != null && height != null && height > 0) {
      final bmi = weight / ((height / 100) * (height / 100));
      setState(() {
        _calculatedBMI = bmi;
      });
      widget.onBMICalculated(bmi);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: _isExpanded ? 4 : 2,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.calculate, color: Color(0xFF4A90E2)),
            title: const Text(
              'BMI Calculator',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: _calculatedBMI != null
                ? Text(
                    'BMI: ${_calculatedBMI!.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : null,
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          focusNode: _weightFocus,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => _calculateBMI(),
                          onSubmitted: (_) => _heightFocus.requestFocus(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          focusNode: _heightFocus,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => _calculateBMI(),
                          onSubmitted: (_) {
                            _calculateBMI();
                            if (widget.nextFocusNode != null) {
                              widget.nextFocusNode!.requestFocus();
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_calculatedBMI != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'BMI: ${_calculatedBMI!.toStringAsFixed(1)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
