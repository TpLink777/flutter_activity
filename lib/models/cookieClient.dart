
import 'package:http/http.dart' as http;

class CookieClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  String? cookie;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (cookie != null) {
      request.headers['Cookie'] = cookie!;
    }

    return _inner.send(request).then((response) {
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        cookie = setCookie;
      }
      return response;
    });
  }
}

final cookieClient = CookieClient();
