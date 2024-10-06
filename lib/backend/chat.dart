import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> chat(String query) async {
  String ans = "";
  final url = Uri.parse(
      'https://oevortex-webscout-api.hf.space/api/chat?q=$query&model=gpt-4o-mini');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    ans = json.decode(response.body);
  }
  return ans;
}
