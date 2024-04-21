import 'package:http/http.dart' as http;
import 'package:new_table/constent/api_constnet.dart';

class ApiService {
  Future getRequest(String api) async {
    // String? token = await storage.read(key: 'jwt');

    var requestUrl = api;
    print("UUUU $requestUrl");
    print("UUUU ${Uri.http(requestUrl, "/account/tree")}");

    var response = await http.get(
      Uri.http(requestUrl, "/account/tree"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*",

        "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE"
        // "Authorization": "Bearer $token",
      },
    );
    print("--------------------------------------------");
    // print("token $token");
    print("urlll $requestUrl");
    print("responseCode ${response.statusCode}");

    if (response.statusCode != 200) {
      if (response.body == "Wrong Credentials") {
        return response;
      }
      //   if (response.statusCode == 401) {
      //     if (!isLoading) {
      //       const storage = FlutterSecureStorage();
      //       isLoading = true;

      //       await storage.delete(key: "jwt").then((value) async {
      //         final context = navigatorKey.currentState!.overlay!.context;
      //         ApiProviedr apiProviedr = context.read<ApiProviedr>();

      //         apiProviedr.setApi(api);
      //         await showDialog(
      //             context: context,
      //             barrierDismissible: false,
      //             builder: (builder) {
      //               return const LoginDialog();
      //             }).then((value) async {
      //           if (value != null) {
      //             api = apiProviedr.getApi!;

      //             requestUrl = "$urlServer/$api";
      //             token = await storage.read(key: 'jwt');

      //             response = await http.get(
      //               Uri.parse(requestUrl),
      //               headers: {
      //                 "Accept": "application/json",
      //                 "content-type": "application/json",
      //                 "Authorization": "Bearer $token",
      //               },
      //             );
      //           }
      //           isLoading = false;
      //         });
      //       });
      //     }
      //   } else {
      //     checkErrorDec(response);
      //   }
      // }
      return response;
    } else {
      return response;
    }
  }
}
