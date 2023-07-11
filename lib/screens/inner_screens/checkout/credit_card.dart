import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handling Backspace correctly and keeping cursor at correct place
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    var date = _addSeparators(newValue.text, '/');
    var offset = newValue.selection.baseOffset;

    if (newValue.text.length == 2) {
      date += '/';
      offset++;
    }

    return newValue.copyWith(
      text: date,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  String _addSeparators(String value, String separator) {
    return value.replaceAllMapped(
      RegExp(r'^(.{2})(.{2})?'),
      (Match match) {
        var result = match.group(1);
        if (match.group(2) != null && result != null) {
          result += separator + match.group(2)!;
        }
        return result!;
      },
    );
  }
}

class CreditCardForm extends StatefulWidget {
  final TextEditingController cardNumberController;
  final TextEditingController fullNameController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvCodeController;

  const CreditCardForm({
    Key? key,
    required this.cardNumberController,
    required this.fullNameController,
    required this.expiryDateController,
    required this.cvvCodeController,
  }) : super(key: key);

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
          const Duration(days: 365 * 10)), // Limit to 10 years in the future
    );

    if (picked != null) {
      final formattedDate = _formatExpiryDate(picked.month, picked.year);
      widget.expiryDateController.text = formattedDate;
    }
  }

  String _formatExpiryDate(int month, int year) {
    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedYear = (year % 100).toString().padLeft(2, '0');
    return '$formattedMonth/$formattedYear';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 16,
          controller: widget.cardNumberController,
          decoration: const InputDecoration(labelText: 'Card number'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your card number';
            } else if (value.length != 16 ||
                (value.startsWith('4') == false &&
                    value.startsWith('5') == false)) {
              return 'Please enter a valid card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: widget.fullNameController,
          decoration: const InputDecoration(labelText: 'Full name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: _selectExpiryDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: widget.expiryDateController,
                    decoration:
                        const InputDecoration(labelText: 'Expiry date (MM/YY)'),
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      ExpiryDateInputFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expiry date';
                      } else if (!_isValidExpiryDate(value)) {
                        return 'Invalid expiry date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 3,
                controller: widget.cvvCodeController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CVV code';
                  } else if (value.length != 3) {
                    return 'CVV code must be 3 digits';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _isValidExpiryDate(String value) {
    // Validate expiry date
    final parts = value.split('/');
    if (parts.length != 2) return false;

    final now = DateTime.now();

    int? month;
    int? year;

    try {
      month = int.parse(parts[0]);
      year = 2000 + int.parse(parts[1]);
    } catch (e) {
      return false;
    }

    // A valid expiry month is from 1 to 12
    if (month < 1 || month > 12) {
      return false;
    }

    if (year < now.year ||
        (year == now.year && month <= now.month)) {
      return false;
    }

    return true;
  }
}
