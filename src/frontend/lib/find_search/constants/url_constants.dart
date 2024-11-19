class UrlConstants {
  static const String baseUrl = "api.content.tripadvisor.com";
  static const String _api = "api/v1";
  static const String _locationPath = "$_api/location";

  static const String nearbySearchUnencodedPath =
      "$_locationPath/nearby_search";

  static const String findSearchUnencodedPath = "$_locationPath/search";

  static String locationDetailsUnencodedPath(String locationId) =>
      "$_locationPath/$locationId/details";

  static String locationPhotosUnencodedPath(String locationId) =>
      "$_locationPath/$locationId/photos";

  static String locationReviewsUnencodedPath(String locationId) =>
      "$_locationPath/$locationId/reviews";
}