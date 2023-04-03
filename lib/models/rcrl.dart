
import '../helpers/constants.dart';
import 'basic_model.dart';
class RcrlModel extends BasicModel {
  final int sampleId;
  final String sampleNumber;
  final String doneAt;
  final String doneBy;
  String? sentAt;
  String? sentBy;
  String? finishedAt;
  String? finishedBy;
  String? imageRequestPath;
  String? imageResultPath;
  final String expectedResult;
  String? actualResult;
  RcrlModel({required this.sampleId,required this.sampleNumber,required this.doneAt,required this.doneBy,this.imageRequestPath,
    this.sentAt,this.finishedAt,this.imageResultPath,this.sentBy,this.finishedBy,
    required this.expectedResult,this.actualResult
  }) : super(sampleId);
  Map<String, Object?> toMap() {
    Map<String,Object?> sampleMap= {
        sampleIdColumn:sampleId,
      sampleNumberColumn:sampleNumber,
        doneAtColumn:doneAt,
        doneByColumn:doneBy,
      sentByColumn:sentBy,
      sentAtColumn:sentAt,
      finishedAtColumn:finishedAt,
      finishedByColumn:finishedBy,
      imageRequestPathColumn:imageRequestPath,
      imageResultPathColumn:imageResultPath,
      expectedResultColumn:expectedResult,
      actualResultColumn:actualResult
      };
    sampleMap.remove(sampleIdColumn);
    return sampleMap;
  }
}
