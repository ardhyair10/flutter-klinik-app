import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:klinik_app/model/klinik.dart';
import 'package:klinik_app/service/klinik_service.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({super.key});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  final MapController _mapController = MapController();
  late Future<List<Klinik>> _klinikListFuture;

  // State untuk menyimpan semua marker, termasuk lokasi user
  List<Marker> _allMarkers = [];

  @override
  void initState() {
    super.initState();
    _klinikListFuture = KlinikService().listKlinik();
  }

  // Fungsi untuk menampilkan detail klinik di bottom sheet
  void _showKlinikDetails(Klinik klinik) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                klinik.namaKlinik,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(klinik.alamat, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text("Petunjuk Arah"),
                  onPressed: () {
                    print("Buka Peta untuk ${klinik.namaKlinik}");
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- FUNGSI BARU UNTUK MENCARI LOKASI PENGGUNA ---
  Future<void> _goToMyLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak.')));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak permanen.')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final myLocation = LatLng(position.latitude, position.longitude);

      _mapController.move(myLocation, 17.0);

      setState(() {
        // Hapus marker "lokasi saya" yang lama jika ada
        _allMarkers.removeWhere((m) => m.key == const Key('myLocation'));
        // Tambahkan marker baru untuk lokasi pengguna
        _allMarkers.add(
          Marker(
            key: const Key('myLocation'),
            width: 80.0,
            height: 80.0,
            point: myLocation,
            child: const Tooltip(
              message: 'Lokasi Saya',
              child: Icon(
                Icons.person_pin_circle,
                size: 60,
                color: Colors.blueAccent,
              ),
            ),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mendapatkan lokasi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lokasi Cabang Klinik")),
      body: FutureBuilder<List<Klinik>>(
        future: _klinikListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data lokasi klinik."));
          }

          // Buat marker untuk setiap klinik dari data API
          // Hanya jika _allMarkers masih kosong (agar tidak terduplikasi saat setState)
          if (_allMarkers.length <= 1) {
            // <= 1 untuk memperhitungkan myLocation marker
            _allMarkers =
                snapshot.data!.map((klinik) {
                  return Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(klinik.latitude, klinik.longitude),
                    child: GestureDetector(
                      onTap: () => _showKlinikDetails(klinik),
                      child: Tooltip(
                        message: klinik.namaKlinik,
                        child: Icon(
                          Icons.location_pin,
                          size: 60,
                          color: Colors.red.shade800,
                        ),
                      ),
                    ),
                  );
                }).toList();
          }

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                snapshot.data![0].latitude,
                snapshot.data![0].longitude,
              ),
              initialZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.klinik_app',
              ),
              MarkerLayer(markers: _allMarkers),
            ],
          );
        },
      ),
      // --- TOMBOL UNTUK LOKASI SAYA ---
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        tooltip: 'Lokasi Saya',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
