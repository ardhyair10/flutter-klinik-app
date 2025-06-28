import '../helpers/api_client.dart';
import '../model/klinik.dart';

class KlinikService {
  Future<List<Klinik>> listKlinik() async {
    try {
      final response = await ApiClient().get('klinik');
      final List data = response.data as List;
      return data.map((json) => Klinik.fromJson(json)).toList();
    } catch (e) {
      print("Error mengambil data klinik: $e");
      return [];
    }
  }
}
