import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> addDataToDatabase({
  required int id,
  required String body,
  required int userId,
  required int mailId,
  required String sendNumber,
  required String sendDate,
  required String sendDestination,
  required String createdAt,
  required String updatedAt,
}) async {
  try {
    final url = Uri.parse('http://127.0.0.1:8000/api/activities');
    // استبدل `your-api-endpoint` بعنوان النهاية الخاصة بالأداة التي تتعامل مع البيانات على الخادم
    final response = await http.post(
      url,
      body: {
        'id': id.toString(),
        'body': body,
        'user_id': userId.toString(),
        'mail_id': mailId.toString(),
        'send_number': sendNumber,
        'send_date': sendDate,
        'send_destination': sendDestination,
        'created_at': createdAt,
        'updated_at': updatedAt,
      },
    );

    if (response.statusCode == 200) {
      // تمت إضافة البيانات بنجاح
      print('تمت إضافة البيانات بنجاح');
    } else {
      // التعامل مع حالة الخطأ أو الفشل
      print('فشل في إضافة البيانات. رمز الحالة: ${response.statusCode}');
    }
  } catch (e) {
    // التعامل مع أي استثناءات أو أخطاء
    print('خطأ: $e');
  }
}
