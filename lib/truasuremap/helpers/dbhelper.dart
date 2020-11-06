import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/place.dart';

class DbHelper {
  final int version = 1;
  Database db;

  List<Place> places = List<Place>();

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(
          await getDatabasesPath(),
          'mapp.db',
        ),
        onCreate: (database, version) {
          database.execute('''
          CREATE TABLE places(
            id INTEGER PRIMARY KEY,
            name TEXT,
            lat DOUBLE,
            lon DOUBLE,
            image TEXT
          )
          ''');
        },
        version: version,
      );
    }
    return db;
  }

  Future deleteMockData() async {
    db = await openDb();
    await db.execute('''
    DELETE FROM places
    ''');
    print('delete all places records');
  }

  Future insertMockData() async {
    db = await openDb();
    await db.execute('''
    INSERT INTO places VALUES (1, "Beautiful park", 13.765, 100.563, "")
    ''');
    await db.execute('''
    INSERT INTO places VALUES (2, "Best Pizza in the world", 13.766, 100.564, "")
    ''');
    await db.execute('''
    INSERT INTO places VALUES (3, "The best icecream on earth", 13.767, 100.565, "")
    ''');
    List places = await db.rawQuery('''
    SELECT * FROM places
    ''');
    print('places: $places');
  }

  Future<List<Place>> getPlaces() async {
    final List<Map<String, dynamic>> maps = await db.query('places');
    print('maps length: ${maps.length}');
    this.places = List.generate(maps.length, (i) {
      return Place(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['lat'],
        maps[i]['lon'],
        maps[i]['image'],
      );
    });
    return this.places;
  }

  Future<int> insertPlace(Place place) async {
    int id = await this.db.insert(
          'places',
          place.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }
}
