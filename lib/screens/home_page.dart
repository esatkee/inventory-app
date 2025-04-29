import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hafta14/helpers/database_helper.dart';
import 'package:hafta14/widgets/app_drawer.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _kategoriler = [];
  bool _isLoading = true;
  int? _selectedKategoriId;
  String _selectedKategoriAd = 'Tüm Ürünler';

  @override
  void initState() {
    super.initState();
    _refreshKategoriler();
  }

  Future<void> _refreshKategoriler() async {
    setState(() {
      _isLoading = true;
    });

    final kategoriler = await DatabaseHelper.getKategoriler();
    setState(() {
      _kategoriler = kategoriler;
      _isLoading = false;
    });
  }

  void _showAddProductDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _adController = TextEditingController();
    final _fiyatController = TextEditingController();
    final _stokController = TextEditingController();
    int? _selectedKategoriIdDialog;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Yeni Ürün Ekle'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _adController,
                        decoration: const InputDecoration(labelText: 'Ürün Adı'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ürün adı giriniz';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _fiyatController,
                        decoration: const InputDecoration(labelText: 'Fiyat'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Fiyat giriniz';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Geçerli bir fiyat giriniz';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _stokController,
                        decoration: const InputDecoration(labelText: 'Stok Miktarı'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Stok miktarı giriniz';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Geçerli bir stok miktarı giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _selectedKategoriIdDialog,
                        hint: const Text('Kategori Seçin'),
                        items: _kategoriler.map((kategori) {
                          return DropdownMenuItem<int>(
                            value: kategori['id'],
                            child: Text(kategori['ad']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategoriIdDialog = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori seçiniz';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İPTAL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseHelper.addUrun(
                        _adController.text,
                        double.parse(_fiyatController.text),
                        int.parse(_stokController.text),
                        _selectedKategoriIdDialog!,
                      );
                      Navigator.pop(context);
                      _refreshKategoriler();
                    }
                  },
                  child: const Text('KAYDET'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditProductDialog(BuildContext context, Map<String, dynamic> urun) {
    final _formKey = GlobalKey<FormState>();
    final _adController = TextEditingController(text: urun['ad']);
    final _fiyatController = TextEditingController(text: urun['fiyat'].toString());
    final _stokController = TextEditingController(text: urun['stok'].toString());
    int? _selectedKategoriIdDialog = urun['kategori_id'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ürünü Düzenle'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _adController,
                        decoration: const InputDecoration(labelText: 'Ürün Adı'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ürün adı giriniz';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _fiyatController,
                        decoration: const InputDecoration(labelText: 'Fiyat'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Fiyat giriniz';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Geçerli bir fiyat giriniz';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _stokController,
                        decoration: const InputDecoration(labelText: 'Stok Miktarı'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Stok miktarı giriniz';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Geçerli bir stok miktarı giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _selectedKategoriIdDialog,
                        hint: const Text('Kategori Seçin'),
                        items: _kategoriler.map((kategori) {
                          return DropdownMenuItem<int>(
                            value: kategori['id'],
                            child: Text(kategori['ad']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategoriIdDialog = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori seçiniz';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İPTAL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseHelper.updateUrun(
                        urun['id'],
                        _adController.text,
                        double.parse(_fiyatController.text),
                        int.parse(_stokController.text),
                        _selectedKategoriIdDialog!,
                      );
                      Navigator.pop(context);
                      _refreshKategoriler();
                    }
                  },
                  child: const Text('GÜNCELLE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> urun) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(urun['ad']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fiyat: ${urun['fiyat']} TL'),
              Text('Stok: ${urun['stok']}'),
              FutureBuilder<Map<String, dynamic>?>(
                future: DatabaseHelper.getKategori(urun['kategori_id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Kategori: Yükleniyor...');
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    return Text('Kategori: ${snapshot.data!['ad']}');
                  }
                  return const Text('Kategori: Bilinmiyor');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('KAPAT'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ürünü Sil'),
          content: const Text('Bu ürünü silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İPTAL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('SİL', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await DatabaseHelper.deleteUrun(id);
      _refreshKategoriler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedKategoriAd),
      ),
      drawer: AppDrawer(
        kategoriler: _kategoriler,
        selectedKategoriId: _selectedKategoriId,
        onKategoriSelected: (id, ad) {
          setState(() {
            _selectedKategoriId = id;
            _selectedKategoriAd = ad;
          });
        },
        onAddProductPressed: () => _showAddProductDialog(context),
        onLogoutPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.getUrunler(kategoriId: _selectedKategoriId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                }

                final urunler = snapshot.data ?? [];

                if (urunler.isEmpty) {
                  return const Center(child: Text('Ürün bulunamadı'));
                }

                return ListView.builder(
                  itemCount: urunler.length,
                  itemBuilder: (context, index) {
                    final urun = urunler[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(urun['ad']),
                        subtitle: Text('Fiyat: ${urun['fiyat']} TL - Stok: ${urun['stok']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditProductDialog(context, urun),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(context, urun['id']),
                            ),
                          ],
                        ),
                        onTap: () => _showProductDetails(context, urun),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}