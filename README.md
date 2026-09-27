# Product Management

Products, categories and stock tracking with Flutter and SQLite.

A coursework project with local storage, category filtering and a basic login example.

<details>
<summary>Setup & technical notes</summary>

### Features

- Add and manage products with name, price, stock quantity and category fields.
- Organise products by category and filter the product list.
- Store application data locally with `sqflite`.
- Demonstrate a local user-login workflow.

### Getting started

Use Flutter with Dart `^3.7.2` and a device supported by `sqflite`.

```bash
flutter pub get
flutter run
```

### Code structure

- `lib/helpers/database_helper.dart` — SQLite schema, queries and data operations.
- `lib/screens/home_page.dart` — product and category interface.
- `lib/screens/login_screen.dart` — local login screen.
- `lib/widgets/app_drawer.dart` — navigation.

### Project scope

This is a learning project. The local authentication example uses seeded accounts and plaintext password comparison; it is not a production authentication system.

</details>
