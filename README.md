# Product Management

A Flutter coursework application for managing products and categories with a local SQLite database.

## Features

- Add and manage products with name, price, stock quantity and category fields.
- Organise products by category and filter the product list.
- Store application data locally with `sqflite`.
- Demonstrate a local user-login workflow.

## Getting started

Use Flutter with Dart `^3.7.2` and a device supported by `sqflite`.

```bash
flutter pub get
flutter run
```

## Code structure

- `lib/helpers/database_helper.dart` — SQLite schema, queries and data operations.
- `lib/screens/home_page.dart` — product and category interface.
- `lib/screens/login_screen.dart` — local login screen.
- `lib/widgets/app_drawer.dart` — navigation.

## Project scope

This is a learning project. The local authentication example uses seeded accounts and plaintext password comparison; it is not a production authentication system.

## Türkçe

Flutter ve SQLite ile geliştirdiğim ürün yönetimi uygulamasıdır. Ürün adı, fiyat, stok ve kategori bilgilerinin yönetilmesini sağlar. Veritabanı işlemleri ayrı bir yardımcı sınıfta toplanmıştır.
