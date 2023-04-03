import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../helpers/constants.dart';
///
///this class for creating [sqlite] database and making [crud] operation on it
///
class RcrlDataBase {
  RcrlDataBase._internal();
  static final RcrlDataBase _db=RcrlDataBase._internal();
  static RcrlDataBase get instance=>_db;
  static Database? _database;
  Future<Database> get database async
  {
    if(_database!=null)
      return _database!;
    _database=await _createDatabase();
    return _database!;
  }
  Future<Database> _createDatabase() async =>
      openDatabase(join(await getDatabasesPath(),databaseName ),
          onCreate: (db, version) {
                 db.execute(
            "CREATE TABLE $rcrlTable($sampleIdColumn INTEGER PRIMARY KEY AUTOINCREMENT, "
                "$sampleNumberColumn TEXT UNIQUE,$doneAtColumn TEXT,$doneByColumn TEXT"
            ",$sentAtColumn TEXT,$sentByColumn TEXT,$finishedAtColumn TEXT,$finishedByColumn TEXT,"
                "$imageRequestPathColumn TEXT UNIQUE,$imageResultPathColumn TEXT UNIQUE,"
                "$expectedResultColumn TEXT ,$actualResultColumn TEXT)");
                 },version:1);
}
