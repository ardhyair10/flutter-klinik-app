import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/poli.dart';

class PoliService {
  Future<List<Poli>> listData() async {
    try {
      final response = await ApiClient().get('poli');
      final List data = response.data as List;
      List<Poli> result = data.map((json) => Poli.fromJson(json)).toList();
      return result;
    } on DioException catch (e) {
      print("Error di listData PoliService: ${e.message}");
      return [];
    }
  }

  Future<Poli?> createPoli(Poli poli) async {
    try {
      var data = poli.toJson();
      final response = await ApiClient().post('poli', data);
      if (response.statusCode == 201) {
        // Asumsi backend mengembalikan data poli yang baru dibuat
        return Poli.fromJson(response.data);
      }
    } on DioException catch (e) {
      print("Error di createPoli PoliService: ${e.message}");
      return null;
    }
    return null;
  }

  Future<Poli?> updatePoli(Poli poli) async {
    try {
      // Pengecekan null dihapus karena poli.id tidak mungkin null
      var data = poli.toJson();
      final response = await ApiClient().put('poli/${poli.id}', data);
      if (response.statusCode == 200) {
        return Poli.fromJson(response.data);
      }
    } on DioException catch (e) {
      print("Error di updatePoli PoliService: ${e.message}");
      return null;
    }
    return null;
  }

  Future<Poli?> getById(String id) async {
    try {
      final response = await ApiClient().get('poli/$id');
      if (response.statusCode == 200) {
        return Poli.fromJson(response.data);
      }
    } on DioException catch (e) {
      print("Error di getById PoliService: ${e.message}");
      return null;
    }
    return null;
  }

  Future<bool> deletePoli(Poli poli) async {
    try {
      // Pengecekan null dihapus karena poli.id tidak mungkin null
      final response = await ApiClient().delete('poli/${poli.id}');
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      print("Error di deletePoli PoliService: ${e.message}");
      return false;
    }
  }
}
