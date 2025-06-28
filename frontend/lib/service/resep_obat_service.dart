import '../helpers/api_client.dart';
import '../model/resep_obat.dart';

class ResepObatService {
  Future<List<ResepObat>> getResepObat() async {
    try {
      final response = await ApiClient().get('resep-obat');
      final List data = response.data as List;
      return data.map((json) => ResepObat.fromJson(json)).toList();
    } catch (e) {
      print("Error mengambil resep obat: $e");
      return [];
    }
  }
}
