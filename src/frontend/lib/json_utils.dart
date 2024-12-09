class JsonUtils {
  static double? parseDouble(String? source) {
    return source == null || source == "" || source == "null"
        ? null
        : double.parse(source);
  }

  static int? parseInt(String? source) {
    return source == null || source == "" || source == "null"
        ? null
        : int.parse(source);
  }

  static String? numToString(num? num) {
    return num.toString();
  }
}