
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../data/database/sample_database.dart';
import '../models/rcrl.dart';
import 'states.dart';

class HomeBloc extends Cubit<AppStates>
{
  HomeBloc() : super(InitState());
  static HomeBloc instance(BuildContext context)=>BlocProvider.of(context);
  SampleDataBase sampleDataBase=SampleDataBase();
  List<RcrlModel> _notFinishedSamples=[];
  List<RcrlModel> _searchedSamples=[];

  List<RcrlModel> get notFinishedSamples=>_notFinishedSamples;
  List<RcrlModel> get searchedSamples=>_searchedSamples;
  addSample(RcrlModel sample)
  {
    sampleDataBase.insert(sample);
    emit(AddSampleState());
  }
  fillSamplesList()async
 {
   _notFinishedSamples=await sampleDataBase.getNonFinishedSamples();
   emit(FillSamplesListState());
 }
  fillSearchedSamplesList(String searchedWord)async
  {
    _searchedSamples=await sampleDataBase.getSearchedSamples(searchedWord);
    emit(FillSearchedSamplesListState());
  }
}