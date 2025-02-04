import 'dart:developer';

import 'package:mysql1/mysql1.dart';

class Database {
  factory Database() => _instance;
  Database._internal(){
    log('------- GET CONNECTION---------');
// _openConnection();
  }
  static final Database _instance = Database._internal();

  MySqlConnection? _connection;

  Future<MySqlConnection> get connection async {
    _connection ??= await _openConnection();
    return _connection!;
  }

  Future<MySqlConnection> _openConnection() async {
    final settings = ConnectionSettings(
      // host: '%',
      port: 3305,        // Default MySQL port
      user: 'root',
      password: 'root',
      db: 'ecommerce',
      // useSSL: true,
    );
    return MySqlConnection.connect(settings);
  }

  Future<void> closeConnection() async {
    await _connection?.close();
    _connection = null;
  }
}
