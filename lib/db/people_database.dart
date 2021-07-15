import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:star_wars/model/db_model.dart';

class PeopleDatabase{
  static final PeopleDatabase instance = PeopleDatabase._init();

  static Database? _database;

  PeopleDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDb('people.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tablePeople(
        ${PeopleFields.id} $idType,
        ${PeopleFields.name} $textType,
        ${PeopleFields.gender} $textType
      )
    ''');
  }

  Future<DbModel> create(DbModel data) async{
    final db = await instance.database;

    // final json = data.toJson();
    // final columns =
    //     '${PeopleFields.name}, ${PeopleFields.gender}';
    // final values =
    //     '${json[PeopleFields.name]}, ${json[PeopleFields.gender]}';
    // final id = await db
    //     .rawInsert('INSERT INTO people ($columns) VALUES ($values)');

    final id = await db.insert(tablePeople, data.toJson());
    return data.copy(id: id);
  }

  Future<List<DbModel>> readAll() async{
    final db = await instance.database;
    final result = await db.query(tablePeople);

    return result.map((json) => DbModel.fromJson(json)).toList();
  }

  Future<int> update(DbModel data) async {
    final db = await instance.database;

    return db.update(
      tablePeople,
      data.toJson(),
      where: '${PeopleFields.id} = ?',
      whereArgs: [data.id],
    );
  }


  Future<int> delete(int id) async{
    final db = await instance.database;
    return await db.delete(
        tablePeople,
        where: '${PeopleFields.id} = ?',
        whereArgs: [id]
    );
  }

  Future close() async{
    final db = await instance.database;
    db.close();

  }
}