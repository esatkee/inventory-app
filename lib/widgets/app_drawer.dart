import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> kategoriler;
  final int? selectedKategoriId;
  final Function(int?, String) onKategoriSelected;
  final Function onAddProductPressed;
  final Function onLogoutPressed;

  const AppDrawer({
    Key? key,
    required this.kategoriler,
    required this.selectedKategoriId,
    required this.onKategoriSelected,
    required this.onAddProductPressed,
    required this.onLogoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Kategoriler',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text('Tüm Ürünler'),
            selected: selectedKategoriId == null,
            onTap: () => onKategoriSelected(null, 'Tüm Ürünler'),
          ),
          ...kategoriler.map((kategori) => ListTile(
                title: Text(kategori['ad']),
                selected: kategori['id'] == selectedKategoriId,
                onTap: () => onKategoriSelected(kategori['id'], kategori['ad']),
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Ürün Ekle'),
            onTap: () => onAddProductPressed(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
            onTap: () => onLogoutPressed(),
          ),
        ],
      ),
    );
  }
}
