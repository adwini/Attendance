class Guard {
  static String? againstNull(dynamic val, String name) {
    if (val == null) {
      return '$name is undifined';
    }
    return null;
  }

  static String? againstEmptyString(dynamic val, String name) {
    final String? isNull = againstNull(val, name);

    if (isNull != null) {
      return isNull;
    }
// -----
    if (val is! String) {
      return '$name is not a String';
    }
// ------
    if (val.isEmpty) {
      return '$name cannot be empty';
    }
    return null;
  }

  static String? againstInvalidEmail(String? val, String name) {
    final String? isEmpty = againstEmptyString(val, name);
    if (isEmpty != null) {
      return isEmpty;
    }
    final RegExp regExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!regExp.hasMatch(val!)) {
      return '$name is invalid';
    }

    return null;
  }

  static String? againstWeakPassword(String? val, String name) {
    final String? isEmpty = againstEmptyString(val, name);
    if (isEmpty != null) {
      return isEmpty;
    }
    final RegExp atleast = RegExp(r"^.{8,16}$");
    final RegExp containSymbol = RegExp(r'[!@#\\$%^&*(),.?":{}|<>]');
    final RegExp containNumber = RegExp(r"[0-9]");

    if (!atleast.hasMatch(val!)) {
      return '$name must be 8-16 Characters Long';
    }
    if (!containSymbol.hasMatch(val)) {
      return '$name must contain at least one Special Symbol';
    }
    if (!containNumber.hasMatch(val)) {
      return '$name must must contain at least One Digit';
    }

    return null;
  }

  static String? againstNotMatch(String? val, String? reference, String name) {
    final String? isNull = againstNull(val, name);
    if (isNull != null) {
      return isNull;
    }

    final String? isEmpty = againstEmptyString(val, name);
    if (isEmpty != null) {
      return isEmpty;
    }

    if (val != reference) {
      return '$name does not match';
    }

    return null;
  }
}
