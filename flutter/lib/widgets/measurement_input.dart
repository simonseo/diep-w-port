import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeasurementInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool readOnly;
  final IconData? icon;
  final VoidCallback? onInfoTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;
  final FocusNode? focusNode;

  const MeasurementInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.icon,
    this.onInfoTap,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  State<MeasurementInput> createState() => _MeasurementInputState();
}

class _MeasurementInputState extends State<MeasurementInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // Rebuild to show/hide clear button
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.onInfoTap != null)
          InkWell(
            onTap: widget.onInfoTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Color(0xFF4A90E2),
                  ),
                ],
              ),
            ),
          )
        else
          Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          readOnly: widget.readOnly,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType ?? const TextInputType.numberWithOptions(decimal: true),
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          onFieldSubmitted: (_) {
            if (widget.onFieldSubmitted != null) {
              widget.onFieldSubmitted!();
            }
          },
          inputFormatters: widget.readOnly
              ? []
              : [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
            suffixIcon: !widget.readOnly && widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      widget.controller.clear();
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: widget.readOnly
              ? null
              : (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid';
                  }
                  return null;
                },
        ),
      ],
    );
  }
}
