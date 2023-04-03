import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sample_bloc.dart';
import '../bloc/states.dart';
import '../helpers/const_widgets.dart';
import '../helpers/constants.dart';
import '../helpers/date.dart';
import '../models/rcrl.dart';
class UpdateSampleView extends StatelessWidget {
  const UpdateSampleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    int sampleId = map[sampleIdKey];
    String sampleNumber= map[sampleNumberKey];
    String  doneBy= map[doneByKey];
    String  doneAt= map[doneAtKey];
    String? sentBy= map[sentByKey];
    String? sentAt= map[sentAtKey];
    String? finishedBy= map[finishedByKey];
    String? finishedAt= map[finishedAtKey];
    String  expectedResult= map[expectedResultKey];
    String? actualResult= map[actualResultKey];
    String? imageRequestPath= map[imageRequestPathKey];
    String? imageResultPath= map[imageResultPathKey];
    var formKey=GlobalKey<FormState>();
    final TextEditingController sampleNumberController=TextEditingController(text:sampleNumber);
    final TextEditingController doneByController=TextEditingController(text:doneBy);
    final TextEditingController doneAtController=TextEditingController(text:doneAt);
    final TextEditingController sentByController=TextEditingController(text:sentBy);
    final TextEditingController sentAtController=TextEditingController(text:sentAt??MyDate.dateToString(DateTime.now()));
    final TextEditingController finishedByController=TextEditingController(text:finishedBy);
    final TextEditingController finishedAtController=TextEditingController(text:finishedAt??MyDate.dateToString(DateTime.now()));
    final TextEditingController expectedResultController=TextEditingController(text:expectedResult);
    final TextEditingController actualResultController=TextEditingController(text:actualResult);
    return
      BlocProvider(
        create: (BuildContext context)=>SampleBloc(),
        child: BlocConsumer<SampleBloc,AppStates>(
          listener: (context,states){},
          builder:(context,state) {
            SampleBloc model=SampleBloc.instance(context);
            if(model.imageRequestPath!=null)
              imageRequestPath=model.imageRequestPath;
            if(model.imageResultPath!=null)
              imageResultPath=model.imageResultPath;
            return Scaffold(
                appBar: AppBar(title: Text('update sample page'),),
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children:  [
                          Text('update sample'.toUpperCase(),style:customStyle()),
                          const SizedBox(height: 15,),
                          appTextFormField(
                              validator: (value){
                                if(value!.isEmpty) {
                                  return 'you must enter sample number';
                                }
                                return null;
                              },
                              hint: 'enter sample number', label: 'sample number',
                              controller:sampleNumberController),
                          const SizedBox(height:10,),
                          appTextFormField(
                              validator: (value){
                                if(value!.isEmpty) {
                                  return 'you must enter name ';
                                }
                                return null;
                              },
                              hint: 'enter name', label: 'done by',
                              controller: doneByController
                          ),
                          const SizedBox(height:10,),
                          appTextFormField(
                              onTap: ()async{
                                DateTime? doneDate=await getDatePicker(context,MyDate.toDate(doneAt));
                                doneAtController.text=MyDate.dateToString(doneDate!);
                              },
                              label:'date', hint:'enter done date',
                              controller: doneAtController
                          ),
                          const SizedBox(height:10,),
                          appTextFormField
                            (
                              validator: (value){
                                if(value!.isEmpty) {
                                  return 'you must enter expected blood group';
                                }
                                return null;
                              },
                              hint: 'enter expected blood group', label: 'expected blood group',
                              controller:expectedResultController
                          ),
                          const SizedBox(height:10,),
                         sentAt==null?SizedBox(): Container(
                            child: Column(
                              children: [
                                appTextFormField(
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return 'you must enter name whose sample sent by';
                                      }
                                      return null;
                                    },
                                    label:'sent by', hint:'enter name',
                                    controller: sentByController
                                ),
                                const SizedBox(height:10,),
                                appTextFormField(
                                    onTap: ()async{
                                      DateTime? sendingDate=await getDatePicker(context,MyDate.toDate(sentAt));
                                      sentAtController.text=MyDate.dateToString(sendingDate!);
                                    },
                                    label:'sending date', hint:'enter sending date',
                                    controller: sentAtController
                                )
                              ],
                            ),
                          )
                         , const SizedBox(height:10,),
                          finishedAt==null?SizedBox():Container(
                            child: Column(
                              children: [
                                appTextFormField(
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return 'you must enter name whose sample finished by';
                                      }
                                      return null;
                                    },
                                    hint: 'enter name ', label: 'finished by',
                                    controller:finishedByController ),
                                const SizedBox(height:10,),
                                appTextFormField(
                                    onTap: ()async{
                                      DateTime? finishingDate=await getDatePicker(context,MyDate.toDate(finishedAt));
                                      finishedAtController.text=MyDate.dateToString(finishingDate!);
                                    },
                                    label:'finishing date', hint:'enter finishing date',
                                    controller: finishedAtController
                                ),
                                const SizedBox(height:10,),
                                appTextFormField(
                                    validator: (value){

                                      if(value!.isEmpty) {
                                        return 'you must enter actual blood group';
                                      }
                                      return null;
                                    },
                                    hint: 'enter actual blood group ', label: 'actual blood group',
                                    controller:actualResultController ),
                              ],
                            ),
                          ),
                          const SizedBox(height:20,),
                          sentAt==null?SizedBox():
                          GestureDetector(
                            onTap: ()
                            {
                              model.setImageRequestPath(sampleNumber);
                              // print('model.imageRequestPath = ${model.imageRequestPath}');
                              // imageRequestPath = model.imageRequestPath;
                              // print('imageRequestPath = ${imageRequestPath}');
                              // viewSnackBar(context, Text(model.imageRequestPath??
                              //        'no image selected'));
                              },
                            child: Container(
                                width: double.infinity,
                                height: 200,
                                child:imageRequestPath == null ?
                                Image.network('https://upload.wikimedia.org/wikipedia/commons/6/62/%22No_Image%22_placeholder.png') :
                                 Image.file(
                                  File(imageRequestPath!),)),
                          ),
                          SizedBox(height: 10,),
                          finishedAt==null?SizedBox():
                          GestureDetector(
                            onTap: ()
                                {
                                  model.setImageResultPath('r_$sampleNumber');
                                  // print('model.imageResultPath = ${model.imageResultPath}');
                                  // imageResultPath = model.imageResultPath;
                                  // print('imageResultPath = ${imageResultPath}');
                                  //
                                  // viewSnackBar(context, Text(model.imageResultPath??'no image selected'));


                                },
                            child: Container(
                                width: double.infinity,
                                height: 200,
                                child:imageResultPath != null ?  Image.file(File(imageResultPath!)):
                              Image.network('https://upload.wikimedia.org/wikipedia/commons/6/62/%22No_Image%22_placeholder.png'),
                          ) )
                          , SizedBox(height: 20,),
                          appButton(onPressed: (){
                            late RcrlModel rcrlSample;
                            if(formKey.currentState!.validate()) {
                              if(sentAt==null)
                              {
                                rcrlSample=RcrlModel(sampleId: sampleId,
                                  sampleNumber: sampleNumberController.text, doneAt: doneAtController.text,
                                  doneBy: doneByController.text, expectedResult: expectedResultController.text,);
                              }
                              else if(finishedAt==null)
                              {
                                rcrlSample=RcrlModel(sampleId: sampleId,
                                  sampleNumber: sampleNumberController.text, doneAt: doneAtController.text,
                                  doneBy: doneByController.text, expectedResult: expectedResultController.text,
                                sentBy: sentByController.text,sentAt: sentAtController.text,
                                    imageRequestPath: imageRequestPath
                                );
                              }
                              else
                              {
                                rcrlSample=RcrlModel(sampleId: sampleId,
                                    sampleNumber: sampleNumberController.text, doneAt: doneAtController.text,
                                    doneBy: doneByController.text, expectedResult: expectedResultController.text,
                                    sentBy: sentByController.text,sentAt: sentAtController.text,imageRequestPath:imageRequestPath,
                                  finishedBy: finishedByController.text,finishedAt: finishedAtController.text,
                                    actualResult: actualResultController.text,imageResultPath:imageResultPath
                                );
                              }
                              model.updateSample(rcrlSample,sampleId);
                              Navigator.pop(context);
                            }
                            },text: 'update reagent'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          },
        ),
      );
  }
}