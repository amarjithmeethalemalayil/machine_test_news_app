import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  final String baseUrl;
  final String? apiKey;

  ApiService({
    required this.client,
    required this.baseUrl,
    this.apiKey,
  });

  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, String>? queryParams,
      }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: {
        if (queryParams != null) ...queryParams,
        if (apiKey != null) 'apiKey': apiKey!,
      },
    );

    try {
      final response = await client.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw HttpException(
          'Failed to load data (status: ${response.statusCode})',
          uri: uri,
        );
      }

      return json.decode(response.body) as Map<String, dynamic>;
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } on HttpException catch (e) {
      throw Exception('Http error occurred: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
