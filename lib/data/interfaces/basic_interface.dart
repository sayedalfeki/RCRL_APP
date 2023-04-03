

import '../../models/basic_model.dart';

abstract class BasicInterface
{
  void insert(BasicModel model);
  void update({required BasicModel model,required int  rowId});
  void delete(int rowId);
  Future<BasicModel> getModelData(int rowId);
  Future<List<BasicModel>> getAllModelsData({String? order});

}