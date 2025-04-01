import 'dart:convert' as convert;
import 'dart:io';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../Network connectivity/network.dart';
import '../../Resource/const/const.dart';
import '../Exceptions/app_exceptions.dart';
import '../local data/prefrence.dart';
import 'base_api_services.dart';

const _timeoutDuration = Duration(seconds: 35);
const Map<int, String> _statusCodes = {
  200: "OK",
  201: "Created",
  202: "Accepted",
  203: "Non-Authoritative Information",
  204: "No Content",
  205: "Reset Content",
  206: "Partial Content",
  207: "Multi-Status (WebDAV)",
  208: "Already Reported (WebDAV)",
  226: "IM Used (HTTP Delta encoding)",
  300: "Multiple Choice",
  301: "Moved Permanently",
  302: "Found",
  303: "See Other",
  304: "Not Modified",
  305: "Use Proxy",
  306: "unused",
  307: "Temporary Redirect",
  308: "Permanent Redirect",
  400: "Bad Request",
  401: "Unauthorized",
  402: "Payment Required",
  403: "Forbidden",
  404: "Not Found",
  405: "Method Not Allowed",
  406: "Not Acceptable",
  407: "Proxy Authentication Required",
  408: "Request Timeout",
  409: "Conflict",
  410: "Gone",
  411: "Length Required",
  412: "Precondition Failed",
  413: "Payload Too Large",
  414: "URI Too Long",
  415: "Unsupported Media Type",
  416: "Range Not Satisfiable",
  417: "Expectation Failed",
  418: "I'm a teapot",
  421: "Misdirected Request",
  422: "Unprocessable Entity (WebDAV)",
  423: "Locked (WebDAV)",
  424: "Failed Dependency (WebDAV)",
  425: "Too Early",
  426: "Upgrade Required",
  428: "Precondition Required",
  429: "Too Many Requests",
  431: "Request Header Fields Too Large",
  451: "Unavailable For Legal Reasons",
  500: "Internal Server Error",
  501: "Not Implemented",
  502: "Bad Gateway",
  503: "Service Unavailable",
  504: "Gateway Timeout",
  505: "HTTP Version Not Supported",
  506: "Variant Also Negotiates",
  507: "Insufficient Storage (WebDAV)",
  508: "Loop Detected (WebDAV)",
  510: "Not Extended",
  511: "Network Authentication Required",
};

class NetworkApiService extends BaseAPiServices {
  @override
  httpGet(
      {bool showLoader = false,
      required String api,
      bool offlineSupport = false,
      offlineData = (dynamic),
      success = (dynamic),
      failure = (dynamic)}) async {
    // 0. check if token not exist then no need to execute api
//    var token =  await Pref.getToken();
//    if(token.length == 0) { // user is not loggedin so ignore requests
//      return;
//    }
    var token = await Pref.getToken();
    //var token = "fqy452nfipgq216wukk6owtb5ut0vygt";

    if (kDebugMode) {
      print('token =$token');
    }
    // 1. checking offline data
    bool offlineDataFound = false;
    if (offlineSupport == true) {
      final cachedResponse = await Pref.getAPIResponse(api: api);
      // debugPrint("local = " + cachedResponse);
      if (cachedResponse.isNotEmpty) {
        offlineDataFound = true;
        offlineData(convert.jsonDecode(cachedResponse));
      }
    }

    // 2. if needed then show loader
    if (showLoader == true) {
      sendBroadcast(Const.showLoader);
    }

    //3. checking network connections
    if (Network.status == NetworkState.DISCONNECTED) {
      failure("No active internet connection");

      return;
    }
    if (showLoader == true && offlineDataFound == false) {
      sendBroadcast(Const.showLoader);
    }

    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        "Authorization": "Bearer $token",
      };

      if (kDebugMode) print("API => $api");

      final apiUrl = Uri.encodeFull(api);
      final uri = Uri.parse(apiUrl);
      dynamic responseJson;

      Response response =
          await http.get(uri, headers: headers).timeout(_timeoutDuration);

      responseJson = returnResponse(response);
      if (kDebugMode) {
        print("responseJson $responseJson");
      }

      if (offlineSupport == true && response.statusCode == 200) {
        Pref.setAPIResponse(responseBody: response.body, api: api);
      }

      success(responseJson);

      sendBroadcast(Const.hideLoader);
    } on TimeoutException catch (_) {
      sendBroadcast(Const.hideLoader);
      if (offlineDataFound == false) {
        failure("Unable to connect to the server");
      }
    } catch (error) {
      sendBroadcast(Const.hideLoader);
      final body = (kDebugMode) ? error.toString() : null;
      if (offlineDataFound == false) {
        failure(body);
      }
    }
  }

  @override
  httpPost(
      {bool showLoader = false,
      required String api,
      dynamic parameters,
      Map<String, String>? header_,
      success = (dynamic),
      failure = (dynamic)}) async {
    dynamic responseJson;
    // 1. if needed then show loader

    // //3. check internet connection
    if (Network.status == NetworkState.DISCONNECTED ||
        Network.status == NetworkState.UNKNOWN) {
      failure("No active internet connection");
      return;
    }
    if (showLoader == true) {
      sendBroadcast(Const.showLoader);
    }
    var token = await Pref.getToken();
    if (kDebugMode) print("token $token");

    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        "Authorization": "Bearer $token",
      };

      if (kDebugMode) print("API => $api");

      final apiUrl = Uri.encodeFull(api);
      final uri = Uri.parse(apiUrl);

      if (parameters != null) {
        parameters = convert.json.encode(parameters);
      }

      Response response = await http
          .post(uri,
              headers: (header_ == null) ? headers : header_, body: parameters)
          .timeout(_timeoutDuration);

      if (kDebugMode) print("JSON => ${response.body}");

      //  var jsonResponse = convert.jsonDecode(response.body);
      responseJson = returnResponse(response);
      success(responseJson);

      if (showLoader) {
        sendBroadcast(Const.hideLoader);
      }
    } on TimeoutException catch (_) {
      sendBroadcast(Const.hideLoader);
      failure("Unable to connect to the server");
    } catch (error) {
      sendBroadcast(Const.hideLoader);

      if (kDebugMode) {
        print(error.toString());
      }
      failure(error.toString());
    }
  }

  @override
  httpPut(
      {bool showLoader = false,
      required String api,
      dynamic parameters,
      Map<String, String>? header_,
      success = (dynamic),
      failure = (dynamic)}) async {
    // 1. if needed then show loader
    if (showLoader == true) {
      sendBroadcast(Const.showLoader);
    }

    //3. check internet connection
    if (Network.status == NetworkState.DISCONNECTED ||
        Network.status == NetworkState.UNKNOWN) {
      failure("No active internet connection");
      return;
    }
    dynamic responseJson;
    var token = await Pref.getToken();
    if (kDebugMode) print("token $token");

    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        "Authorization": "Bearer $token",
      };

      if (kDebugMode) print("API => $api");

      final apiUrl = Uri.encodeFull(api);
      final uri = Uri.parse(apiUrl);

      if (parameters != null) {
        parameters = convert.json.encode(parameters);
      }

      Response response = await http
          .put(uri,
              headers: (header_ == null) ? headers : header_, body: parameters)
          .timeout(_timeoutDuration);

      if (kDebugMode) print("JSON => ${response.body}");
      responseJson = returnResponse(response);
      success(responseJson);

      sendBroadcast(Const.hideLoader);
    } on TimeoutException catch (_) {
      sendBroadcast(Const.hideLoader);
      failure("Unable to connect to the server");
    } catch (error) {
      sendBroadcast(Const.hideLoader);

      failure(error.toString());
    }
  }

  @override
  httpDelete(
      {bool showLoader = false,
      required String api,
      success = (dynamic),
      failure = (dynamic)}) async {
    dynamic responseJson;
    var token = await Pref.getToken();

    //var token = "fqy452nfipgq216wukk6owtb5ut0vygt";
    if (kDebugMode) print("token $token");

    // 2. if needed then show loader
    if (showLoader == true) {
      sendBroadcast(Const.showLoader);
    }

    //3. checking network connections
    if (Network.status == NetworkState.DISCONNECTED ||
        Network.status == NetworkState.UNKNOWN) {
      failure("No active internet connection");
      return;
    }

    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      if (kDebugMode) print("API => $api");

      final apiUrl = Uri.encodeFull(api);
      final uri = Uri.parse(apiUrl);

      Response response =
          await http.delete(uri, headers: headers).timeout(_timeoutDuration);
      //print("response => ${response.body}");

      if (response.statusCode == 401) {
        sendBroadcast(Const.unAuth);
      } else {
        responseJson = returnResponse(response);
        success(responseJson);
      }
      sendBroadcast(Const.hideLoader);
    } on TimeoutException catch (_) {
      sendBroadcast(Const.hideLoader);
    } catch (error) {
      sendBroadcast(Const.hideLoader);
    }
  }

  dynamic returnResponse(http.Response response) {
    String status = "";
    if (_statusCodes.containsKey(response.statusCode)) {
      status = _statusCodes[response.statusCode] as String;
    }
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = convert.jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = convert.jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorizedExceptions(response.body.toString());
      default:
        throw FetchDataException(
            "Error occured while communicating with server with status code ${response.statusCode.toString()} $status"
            "");
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
