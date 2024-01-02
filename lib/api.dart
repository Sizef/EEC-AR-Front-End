import 'package:http/http.dart' as http;
import 'dart:convert';


Future<void> getData() async {
  try {
    final Uri url = Uri.parse('http://100.103.184.243:5000/api/data');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
