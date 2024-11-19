import 'dart:convert';

import './constants/url_constants.dart';
import './models/api_settings.dart';
import '../../network_utils.dart';
import './models/search_response.dart';

import './find_search_parameters.dart';

/// Class that communicates with the find search api
class FindSearch {
  final ApiSettings _settings;

  FindSearch(this._settings);

  /// Get a [SearchResponse] which from the passed [FindSearchParameters]
  /// The Location Search request returns up to 10 locations found by the given search query.
  ///You can use category ("hotels", "attractions", "restaurants", "geos"), phone number, address, and latitude/longitude to search with more accuracy.
  Future<SearchResponse> get(FindSearchParameters params) async {
    var uri = Uri.https(UrlConstants.baseUrl,
        UrlConstants.findSearchUnencodedPath, _createQueryParameters(params));
    Map<String, dynamic> headers = {
      "accept": "application/json",
    };
    var response = await NetworkUtils.getRequest(uri, headers: headers);
    return SearchResponse.fromJson(jsonDecode(response.body));
  }

  Map<String, dynamic> _createQueryParameters(FindSearchParameters params) {
    Map<String, dynamic> queryParams = {
      "key": _settings.apiKey,
    };
    NetworkUtils.addIfNotNull(
        queryParams, MapEntry("language", _settings.language?.name));
    NetworkUtils.addIfNotNull(
        queryParams, MapEntry("language", params.language?.name));
    NetworkUtils.addIfNotNull(queryParams, MapEntry("address", params.address));
    NetworkUtils.addIfNotNull(queryParams, MapEntry("phone", params.phone));
    NetworkUtils.addIfNotNull(
        queryParams, MapEntry("searchQuery", params.searchQuery));
    return queryParams;
  }
}