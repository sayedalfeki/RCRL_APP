import 'package:sqflite_common/sqlite_api.dart';
import '../../helpers/constants.dart';
import '../../models/basic_model.dart';
import '../../models/rcrl.dart';
import '../interfaces/basic_interface.dart';
import 'database.dart';
class SampleDataBase extends BasicInterface
{
Future<Database> _database=RcrlDataBase.instance.database;
  @override
  void insert(BasicModel model) async{
   final db=await _database;
   db.insert(rcrlTable,model.toMap());
  }
  @override
  void update({required BasicModel model, required int rowId})async {
    final db=await _database;
    db.update(rcrlTable,model.toMap(),where: '$sampleIdColumn=?',whereArgs: [rowId]);
  }
void updateSending(int sampleId,{required String sentAt, String? sentBy,
  String? imageRequestPath})async
{
  final db = await _database;
  Map<String,Object?> values={
    sentAtColumn:sentAt,
    sentByColumn:sentBy,
    imageRequestPathColumn:imageRequestPath
  };
  db.update(rcrlTable,values,where:'$sampleIdColumn=?',whereArgs: [sampleId]);
}
void updateFinishing(int sampleId,{required String finishedAt,String? finishedBy,required String actualResult,
  String? imageResultPath})async
{
  final db = await _database;
  Map<String,Object?> values={
    finishedAtColumn:finishedAt,
    finishedByColumn:finishedBy,
    actualResultColumn:actualResult,
    imageResultPathColumn:imageResultPath
  };
  db.update(rcrlTable,values,where:'$sampleIdColumn=?',whereArgs: [sampleId]);
}
  @override
  void delete(int rowId)async {
    final db=await _database;
    db.delete(rcrlTable,where: '$sampleIdColumn=?',whereArgs: [rowId]);
  }
List<RcrlModel> _getSamples(List<Map<String,dynamic>> samplesMap)
{
  List<RcrlModel> samples=[];
  if(samplesMap.isNotEmpty)
  {
    samples=List.generate(samplesMap.length, (index){
      return RcrlModel(sampleId:samplesMap[index][sampleIdColumn], sampleNumber: samplesMap[index][sampleNumberColumn],
          doneAt:samplesMap[index][doneAtColumn], doneBy:samplesMap[index][doneByColumn],
          expectedResult:samplesMap[index][expectedResultColumn],
          actualResult: samplesMap[index][actualResultColumn],
          finishedAt: samplesMap[index][finishedAtColumn],
          finishedBy: samplesMap[index][finishedByColumn],
          sentAt: samplesMap[index][sentAtColumn],
          sentBy: samplesMap[index][sentByColumn],
          imageRequestPath:samplesMap[index][imageRequestPathColumn],
          imageResultPath: samplesMap[index][imageResultPathColumn]
      );
    });
  }
  return samples;
}
  @override
  Future<List<RcrlModel>> getAllModelsData({String? order})async {
    final db=await _database;
    List<Map<String,dynamic>> samplesMap=await db.query(rcrlTable);
return _getSamples(samplesMap);
  }
  @override
  Future<RcrlModel> getModelData(int rowId)async {
    final db=await _database;
    List<Map> sampleMap=await db.query(rcrlTable,where: '$sampleIdColumn=?',whereArgs: [rowId]);
    return RcrlModel(sampleId:sampleMap[0][sampleIdColumn], sampleNumber: sampleMap[0][sampleNumberColumn],
        doneAt:sampleMap[0][doneAtColumn], doneBy:sampleMap[0][doneByColumn],
        expectedResult:sampleMap[0][expectedResultColumn],
        actualResult: sampleMap[0][actualResultColumn],
        finishedAt: sampleMap[0][finishedAtColumn],
        finishedBy: sampleMap[0][finishedByColumn],
        sentAt: sampleMap[0][sentAtColumn],
        sentBy: sampleMap[0][sentByColumn],
        imageRequestPath:sampleMap[0][imageRequestPathColumn],
        imageResultPath: sampleMap[0][imageResultPathColumn]
    );
  }

Future<List<RcrlModel>> getNonSentSamples()async
{

  final db = await _database;
  List<Map<String, dynamic>> samplesMap = await db.query(rcrlTable,
        where:"$sentAtColumn is null");
    return _getSamples(samplesMap);
}
Future<List<RcrlModel>> getNonFinishedSamples()async
{
  final db = await _database;
  List<Map<String, dynamic>> samplesMap = await db.query(rcrlTable,
      where:"$finishedAtColumn is null",orderBy: '$doneAtColumn desc');
  return _getSamples(samplesMap);
}
 Future<List<RcrlModel>> getSearchedSamples(String searchedWord)async
{
  final db = await _database;
  List<Map<String, dynamic>> samplesMap = await db.query(rcrlTable,
        where:"$sampleNumberColumn like '%$searchedWord%' or $doneByColumn like '%$searchedWord%' or "
            "$doneAtColumn like '%$searchedWord%' or"
            " $sentAtColumn like '%$searchedWord%' or "
            "$finishedAtColumn like '%$searchedWord%' or $sentByColumn like '%$searchedWord%' or "
            "$finishedByColumn like '%$searchedWord%' or $expectedResultColumn like '%$searchedWord%' or"
            " $actualResultColumn like '%$searchedWord%' ",orderBy: '$doneAtColumn desc' );
    return _getSamples(samplesMap);
}

}