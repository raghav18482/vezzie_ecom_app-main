abstract class BaseAPiServices {
  Future<dynamic> httpGet(
      {bool showLoader = false,
      required String api,
      bool offlineSupport = false,
      offlineData = (dynamic),
      success = (dynamic),
      failure = (String)});


  Future<dynamic> httpDelete(
      {bool showLoader = false,
      required String api,
      success = (dynamic),
      failure = (String)});
                                                              
  Future<dynamic> httpPost(
      {bool showLoader = false,
      required String api,
      dynamic parameters,
      Map<String, String>? header_,
      success = (dynamic),
      failure = (String)});

      
  Future<dynamic> httpPut(
      {bool showLoader = false,
      required String api,
      dynamic parameters,
      Map<String, String>? header_,
      success = (dynamic),
      failure = (String)});
}
