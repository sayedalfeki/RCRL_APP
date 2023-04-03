import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../data/database/sample_database.dart';
import '../helpers/helper.dart';
import '../models/rcrl.dart';
import 'states.dart';
class SampleBloc extends Cubit<AppStates>
{
  SampleBloc() : super(InitState());
  static SampleBloc instance(BuildContext context)=>BlocProvider.of(context);
  SampleDataBase sampleDataBase=SampleDataBase();
  RcrlModel? _sample;
  bool isDeleted=false;
   String? _imageRequestPath;
  String? _imageResultPath;
  double width=120;
  double height=50;
  int maxLine=1;
  bool isConnected=false;
  RcrlModel? get sample=>_sample;
  String? get imageRequestPath=>_imageRequestPath;
  String? get imageResultPath=>_imageResultPath;
  listenToConnection()async
  {
    StreamSubscription<InternetConnectionStatus> listener=InternetConnectionChecker()
        .onStatusChange.listen((status) {
          switch(status)
          {
            case InternetConnectionStatus.connected:
              isConnected=true;

              break;
            case InternetConnectionStatus.disconnected:
              isConnected=false;

              break;
          }
    });
    await Future<void>.delayed(const Duration(seconds: 30));
  await listener.cancel();
  emit(ConnectionCheckerState());
  }
  changeWidth()
  {
    width=150;
    maxLine=2;
    emit(ChangeWidthState());
  }
  changeHeight()
  {
      height=70;
      emit(ChangeHeightState());
  }
  setImageRequestPath(String pathName)async {
    _imageRequestPath=(await Helper.getPhoto(pathName,ImageSource.gallery));
    emit(ChangeRequestPathState());
  }
  setImageResultPath(String pathName)async {
    _imageResultPath=(await Helper.getPhoto(pathName,ImageSource.gallery));
    emit(ChangeResultPathState());
  }
  updateSample(RcrlModel sample,int sampleId)
  {
    sampleDataBase.update(model: sample, rowId:sampleId);
    emit(UpdateSampleState());
  }
  sentSample(int sampleId,{required String sentAt,String? sentBy,String? imageRequestPath})
  {
    sampleDataBase.updateSending(sampleId, sentAt: sentAt,sentBy: sentBy,imageRequestPath: imageRequestPath);
    emit(SendSampleState());
  }
  finishSample(int sampleId,{required String finishedAt,required String actualResult,
    String? finishedBy,String? imageResultPath})
  {
sampleDataBase.updateFinishing(sampleId, finishedAt: finishedAt, actualResult: actualResult,
finishedBy: finishedBy,imageResultPath: imageResultPath);
emit(FinishSampleState());
  }
  deleteSample(int sampleId)
  {
    sampleDataBase.delete(sampleId);
    emit(DeleteSampleState());
  }
  changeIsDeleted()
  {
    isDeleted=true;
    emit(ChangeDeletingState());
  }
  getSample(int sampleId)async
  {
    _sample=await sampleDataBase.getModelData(sampleId);
    emit(GetSampleState());
  }
}