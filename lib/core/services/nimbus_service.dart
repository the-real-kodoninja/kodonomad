import 'package:http/http.dart' as http;
import 'dart:convert';

class NimbusService {
  static const String apiKey = 'your_nimbus_api_key';
  static const String apiUrl = 'https://api.nimbus.ai/v1/chat';

  Future<String> chat(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
      body: jsonEncode({'message': message, 'context': 'nomadic'}),
    );
    return jsonDecode(response.body)['reply'];
  }
}

final nimbusServiceProvider = Provider((ref) => NimbusService());
