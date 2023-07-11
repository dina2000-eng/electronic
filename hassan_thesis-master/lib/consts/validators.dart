class MyValidators {
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please your name';
    } else if (value.length < 4) {
      return "Name can't be less than 5 characters";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }

  static String? validatePhoneNumber({String? phone}) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    if (phone == null || !regex.hasMatch(phone)) {
      return 'Enter valid phone number';
    } else {
      return null;
    }
  }
}
