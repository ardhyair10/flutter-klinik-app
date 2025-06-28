import '../helpers/api_client.dart';
import '../model/artikel.dart';

class ArtikelService {
  Future<List<Artikel>> listArtikel() async {
    try {
      final response = await ApiClient().get('artikel');
      final List data = response.data as List;
      return data.map((json) => Artikel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Artikel?> getById(int id) async {
    try {
      final response = await ApiClient().get('artikel/$id');
      return Artikel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
