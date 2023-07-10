import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:untitled15/models_localhost/api_response.dart';
import 'package:untitled15/services/user_service.dart';
import 'package:untitled15/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> getAttachment(String imageUrl) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final http.Response response = await http
        .get(Uri.parse('$attachmentUrl/$imageUrl'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    // print(response.bodyBytes);
    // print(response.statusCode);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = response.bodyBytes;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print('attachment services: ${e.toString()}');
    apiResponse.error = serverError;
  }
  return apiResponse;
}


Future<int> uploadImage(File file, mailId) async {
  String token = await getToken();
  var request = http.MultipartRequest("POST", Uri.parse(attachmentUrl));
//create multipart using filepath, string or bytes
  var pic = await http.MultipartFile.fromPath('image', file.path);
  request.fields['mail_id'] = mailId.toString();
  request.fields['title'] = 'image_${DateTime.now()}';
//add multipart to request
  request.files.add(pic);
  request.headers
      .addAll({'Accept': 'application/json', 'Authorization': 'Bearer $token'});
  var response = await request.send();

//Get the response from the server
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  print(responseString);
  return response.statusCode;
}


Future<bool> addAttachments({
  required Int? mailId,
  List<XFile>? images,
}) async {
  final prefs = await SharedPreferences.getInstance();

  String token = '';
  if (prefs.getString('token') != null) {
    token = prefs.getString('token')!;
  }

  var headers = {'Authorization': token};
  var request = http.MultipartRequest(
      'POST', Uri.parse(attachmentUrl));
  request.fields
      .addAll({'mail_id': mailId.toString(), 'title': DateTime.now().toString()});

  if (images != null) {
    for (var image in images) {
      request.files
          .add(await http.MultipartFile.fromPath('image', image.path));
    }
  }
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    return true;
  }
}