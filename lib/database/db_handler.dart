import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/booking_model.dart';
import '../models/driver_model.dart';
import '../models/expense_model.dart';
import '../models/vehicle_model.dart';

class DBHandler {
  static Database? _database;

  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'ride_booking.db');
    _database = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        vehicleNo TEXT,
        model TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE drivers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        licenseNumber TEXT,
        phoneNumber TEXT,
        city TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Booking (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customername TEXT,
        customercontact TEXT,
        date TEXT,
        amount INTEGER,
        vnum TEXT,
        driver TEXT
      )
    ''');
    //   driver TEXT,
    await db.execute('''
      CREATE TABLE Expense (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookingid INTEGER,
        narration TEXT,
        amount int
      )
    ''');
  }

  //vehicles

  Future<List<Vehicle>> getVehicles() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query('vehicles');
    List<Vehicle> vehicleList = rows
        .map((e) => Vehicle(
            id: e['id'],
            name: e['name'],
            vehicleNo: e['vehicleNo'],
            model: e['model'],
            image: e['image']))
        .toList();
    return vehicleList;
  }

  Future<List<Vehicle>> getVehiclesWithNumber(String number) async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      'vehicles',
      where: 'vehicleNo=?',
      whereArgs: [number],
    );
    List<Vehicle> vehicleList = rows
        .map((e) => Vehicle(
            id: e['id'],
            name: e['name'],
            vehicleNo: e['vehicleNo'],
            model: e['model'],
            image: e['image']))
        .toList();
    return vehicleList;
  }

  Future<int> insertVehicle(Vehicle vehicle) async {
    final db = await database;
    int rowId = await db.insert('vehicles', vehicle.toMap());
    return rowId;
  }

  Future<int> deleteVehicle(String name) async {
    final db = await database;
    int rowId = await db.delete(
      'vehicles',
      where: 'name = ?',
      whereArgs: [name],
    );
    return rowId;
  }

//drivers

  Future<List<Driver>> getDrivers() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query('drivers');
    List<Driver> driverList = rows
        .map((e) => Driver(
            id: e['id'],
            name: e['name'],
            licenseNumber: e['licenseNumber'],
            phoneNumber: e['phoneNumber'],
            city: e['city'],
            image: e['image']))
        .toList();
    return driverList;
  }

  Future<List<Driver>> getDriverWithName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      'drivers',
      where: 'name=?',
      whereArgs: [name],
    );
    List<Driver> driverList = rows
        .map((e) => Driver(
            id: e['id'],
            name: e['name'],
            licenseNumber: e['licenseNumber'],
            phoneNumber: e['phoneNumber'],
            city: e['city'],
            image: e['image']))
        .toList();
    return driverList;
  }

  Future<int> insertDriver(Driver driver) async {
    final db = await database;
    int rowId = await db.insert('drivers', driver.toMap());
    return rowId;
  }

  Future<int> deleteDriver(String name) async {
    final db = await database;
    int rowId = await db.delete(
      'drivers',
      where: 'name = ?',
      whereArgs: [name],
    );
    return rowId;
  }

  //booking
  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    int rowId = await db.insert('Booking', booking.toMap());
    return rowId;
  }

  Future<List<Booking>> getBooking() async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query('Booking');
    print(rows);
    List<Booking> bookingList = rows
        .map(
          (e) => Booking(
              id: e['id'],
              customername: e['customername'],
              customercontact: e['customercontact'],
              vnum: e['vnum'],
              date: e['date'],
              amount: e['amount'],
              driver: e['driver']),
        )
        .toList();
    print(bookingList);
    return bookingList;
  }

  Future<List<Booking>> getCustomerBasedBooking(String customername) async {
    final db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      'Booking',
      where: 'customername LIKE ? OR vnum LIKE ?',
      whereArgs: ['%$customername%', '%$customername%'],
    );
    print(rows);
    List<Booking> bookingList = rows
        .map(
          (e) => Booking(
              id: e['id'],
              customername: e['customername'],
              customercontact: e['customercontact'],
              vnum: e['vnum'],
              date: e['date'],
              amount: e['amount'],
              driver: e['driver']),
        )
        .toList();
    print(bookingList);
    return bookingList;
  }

  //expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    int rowId = await db.insert('Expense', expense.toMap());
    return rowId;
  }

  Future<List<Expense>> getExpenses(int bookingId) async {
    final db = await database;
    final List<Map<String, dynamic>> rows =
        await db.query('Expense', where: 'bookingid=?', whereArgs: [bookingId]);
    print(rows);
    List<Expense> expensesLst = rows
        .map(
          (e) => Expense(
              id: e['id'],
              bookingid: e['bookingid'],
              narration: e['narration'],
              amount: e['amount']),
        )
        .toList();
    print(expensesLst);
    return expensesLst;
  }
}
