import 'package:formz/formz.dart';

// Define input validation errors
enum StockError { empty, format, value }

// Extend FormzInput and provide the input type and error type.
class Stock extends FormzInput<int, StockError> {
  // Call super.pure to represent an unmodified form input.
  const Stock.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Stock.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == StockError.empty) return 'El stock es requerido';
    if (displayError == StockError.format) {
      return 'El stock debe ser un número entero';
    }
    if (displayError == StockError.value) return 'El stock debe ser positivo';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StockError? validator(int value) {
    if (value.toString().isEmpty) return StockError.empty;

    final isInteger = int.tryParse(value.toString()) != null;

    if (!isInteger) return StockError.format;

    if (value < 0) return StockError.value;

    return null;
  }
}
