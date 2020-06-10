import 'package:brenco_keys/models/key.dart' as LicenseKey;
import 'package:http/http.dart';
import 'dart:convert';


final API api = API();
const BASE_URL = 'https://brenco-keys.herokuapp.com';

class API {
  final client = Client();

  Future<List<LicenseKey.Key>> fetchKeys() async {
    List<LicenseKey.Key> keys = [];
    final response = await client.get("$BASE_URL/api/keys");

    if (response.body.startsWith("null")) {
      return keys;
    }

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      keys = List<LicenseKey.Key>.from(l.map((model) => LicenseKey.Key.fromJson(model)));
      return keys;
    } else {
      throw Exception('Failed to load keys');
    }
  }

  Future<bool> createKey(String name) async {
    final response = await client.post("$BASE_URL/api/keys/create", body: {
      "name": name,
    });

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create the key, please try again later.');
    }
  }

  Future<bool> removeKey(int id) async {
    final response = await client.post("$BASE_URL/api/keys/remove/$id", body: {});

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to remove the key, please try again later.');
    }
  }
}
