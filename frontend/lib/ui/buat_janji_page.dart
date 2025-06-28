import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:klinik_app/model/poli.dart';
import 'package:klinik_app/model/dokter.dart';
import 'package:klinik_app/service/poli_service.dart';
import 'package:klinik_app/service/dokter_service.dart';
import 'package:klinik_app/service/janji_temu_service.dart';

class BuatJanjiPage extends StatefulWidget {
  final Poli? poli;
  const BuatJanjiPage({super.key, this.poli});

  @override
  State<BuatJanjiPage> createState() => _BuatJanjiPageState();
}

class _BuatJanjiPageState extends State<BuatJanjiPage> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalCtrl = TextEditingController();
  final _waktuCtrl = TextEditingController();
  final _keluhanCtrl = TextEditingController();

  int? _selectedPoliId;
  int? _selectedDokterId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  bool _isDokterLoading = false;

  late Future<List<Poli>> _poliListFuture;
  List<Dokter> _dokterList = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    if (widget.poli != null) {
      _selectedPoliId = widget.poli!.id;
      _fetchDoctors(_selectedPoliId!);
    }
    _poliListFuture = PoliService().listData();
  }

  @override
  void dispose() {
    _tanggalCtrl.dispose();
    _waktuCtrl.dispose();
    _keluhanCtrl.dispose();
    super.dispose();
  }

  void _fetchDoctors(int poliId) async {
    setState(() {
      _isDokterLoading = true;
      _dokterList = [];
      _selectedDokterId = null;
    });
    try {
      List<Dokter> doctors = await DokterService().getByPoliId(poliId);
      setState(() {
        _dokterList = doctors;
      });
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          _isDokterLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalCtrl.text = DateFormat(
          'EEEE, dd MMMM yyyy',
          'id_ID',
        ).format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _waktuCtrl.text = picked.format(context);
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPoliId == null ||
          _selectedDokterId == null ||
          _selectedDate == null ||
          _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap lengkapi semua pilihan'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() => _isLoading = true);
      try {
        bool success = await JanjiTemuService().createJanjiTemu(
          poliId: _selectedPoliId!,
          dokterId: _selectedDokterId!,
          tanggal: _selectedDate!,
          waktu: _selectedTime!,
          keluhan: _keluhanCtrl.text.trim(),
        );

        if (mounted) {
          if (success) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Janji temu berhasil dibuat!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal membuat janji temu'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Janji Temu")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.poli != null)
                TextFormField(
                  readOnly: true,
                  initialValue: widget.poli!.namaPoli,
                  decoration: const InputDecoration(
                    labelText: 'Poli',
                    prefixIcon: Icon(Icons.local_hospital_outlined),
                  ),
                )
              else
                FutureBuilder<List<Poli>>(
                  future: _poliListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("Tidak ada data poli.");
                    }
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Poli',
                        prefixIcon: Icon(Icons.local_hospital_outlined),
                      ),
                      items:
                          snapshot.data!
                              .map(
                                (poli) => DropdownMenuItem(
                                  value: poli.id,
                                  child: Text(poli.namaPoli),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPoliId = value;
                            _fetchDoctors(value);
                          });
                        }
                      },
                      validator:
                          (value) => value == null ? 'Harap pilih poli' : null,
                    );
                  },
                ),
              const SizedBox(height: 20),
              if (_isDokterLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_selectedPoliId != null)
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Pilih Dokter',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  value: _selectedDokterId,
                  hint: Text(
                    _dokterList.isEmpty
                        ? "Tidak ada dokter tersedia"
                        : "Pilih salah satu dokter",
                  ),
                  items:
                      _dokterList
                          .map(
                            (dokter) => DropdownMenuItem(
                              value: dokter.id,
                              child: Text(dokter.namaDokter),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDokterId = value;
                    });
                  },
                  validator:
                      (value) => value == null ? 'Harap pilih dokter' : null,
                ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _tanggalCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Pilih Tanggal",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _selectDate,
                validator:
                    (value) =>
                        (value?.isEmpty ?? true) ? 'Harap pilih tanggal' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _waktuCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Pilih Waktu",
                  prefixIcon: Icon(Icons.access_time),
                ),
                onTap: _selectTime,
                validator:
                    (value) =>
                        (value?.isEmpty ?? true) ? 'Harap pilih waktu' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _keluhanCtrl,
                decoration: const InputDecoration(
                  labelText: "Keluhan",
                  hintText: "Jelaskan keluhan Anda...",
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.edit_note),
                ),
                maxLines: 4,
                validator:
                    (value) =>
                        (value?.isEmpty ?? true) ? 'Harap isi keluhan' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                        : const Text('BUAT JANJI'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
