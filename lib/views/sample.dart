import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sample_bloc.dart';
import '../bloc/states.dart';
import '../helpers/const_widgets.dart';
import '../helpers/constants.dart';
import '../helpers/date.dart';
import '../helpers/helper.dart';
import 'package:image_picker/image_picker.dart';
class SampleDetailsPage   extends StatelessWidget   {
  const SampleDetailsPage({Key? key}):super(key: key);
  @override
  Widget build(BuildContext context) {
    Map  sampleMap=ModalRoute.of(context)!.settings.arguments as Map;
    int sampleId=sampleMap[sampleIdKey];
    return
      BlocProvider(
      create: (context)=>SampleBloc()..getSample(sampleId)..listenToConnection(),
      child: BlocConsumer<SampleBloc,AppStates>(
        listener: (context,state){},
        builder:(context,state) {
          SampleBloc model=SampleBloc.instance(context);
          model.getSample(sampleId);

          if (model.sample==null) {
            return SizedBox();
          } else {
            return Scaffold(
          appBar: AppBar(title: Text("sample page"),
          actions: [
            IconButton(onPressed:(){
              // if(model.sample!.sentAt==null)
              // {
              //   viewSnackBar(context,Text('click send sample first'));
              //   return;
              // }
              Navigator.pushNamed(context,updatePageRoute,arguments: {
               sampleIdKey:sampleId,
                sampleNumberKey:model.sample!.sampleNumber,
                doneByKey:model.sample!.doneBy,
                doneAtKey:model.sample!.doneAt,
                sentByKey:model.sample!.sentBy,
                sentAtKey:model.sample!.sentAt,
                finishedByKey:model.sample!.finishedBy,
                finishedAtKey:model.sample!.finishedAt,
                expectedResultKey:model.sample!.expectedResult,
                actualResultKey:model.sample!.actualResult,
                imageRequestPathKey:model.sample!.imageRequestPath,
                imageResultPathKey:model.sample!.imageResultPath,
              });
            }, icon:Icon(Icons.edit)),
            IconButton(onPressed: (){
             deleteSample(model, context, sampleId);
            }, icon:Icon(Icons.delete))
          ],
          ),
          body:
         Container(padding: EdgeInsets.only(left: 10, top: 10),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       Text(model.sample!.sampleNumber,style: customStyle(),),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  model.changeWidth();
                                  model.changeHeight();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  height:model.height,
                                  width:model.width,
                                  decoration: BoxDecoration(
                                      color: model.sample!.actualResult==null?Colors.white:model.sample!.expectedResult.
                                      replaceAll(' ','').toLowerCase()==model.sample!.actualResult?.replaceAll(' ','').toLowerCase()?
                                      Colors.white:Colors.red,
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      Text('expected result'),
                                      Spacer(),
                                      Text(model.sample!.expectedResult,maxLines:model.maxLine,overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                ),
                              ),
                              //model.sample!.actualResult==null?SizedBox():Spacer(),
                            model.sample!.actualResult==null?SizedBox():
                            GestureDetector(
                              onTap: (){
                                model.changeWidth();
                                model.changeHeight();
                              },
                              child: Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  height:model.height,
                                  width:model.width,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      Text('actual result'),
                                      Spacer(),
                                      Text(model.sample!.actualResult??'unknown',maxLines:model.maxLine,overflow: TextOverflow.ellipsis,)
                                    ],
                                  ),
                                ),
                            ),

                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              sampleRow(text1:'done by:', text2:model.sample!.doneBy),
                              SizedBox(height: 5,),
                              sampleRow(text1:'done at:', text2:model.sample!.doneAt),
                              SizedBox(height: 5,),
                              sampleRow(text1:'sent by', text2: model.sample!.sentBy??'unknown'),
                              SizedBox(height: 5,),
                              sampleRow(text1:'sent at:',text2:
                              model.sample!.sentAt ?? 'not sent yet'),
                              SizedBox(height: 5,),
                              sampleRow(text1:'finished at:',text2:model.sample!.finishedAt ?? 'not finished yet'),
                              SizedBox(height: 15,),
                              sampleRow(text1:'finished by : ', text2:model.sample!.finishedBy??'unknown')
                            ],
                          ),
                        )
                        ,
                        Expanded(
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: model.sample!.imageRequestPath != null ?
                                      GestureDetector(
                                        onTap: (){
                                          showDialog(context: context, builder:(context)
                                          {
                                            return AlertDialog(
                                              content: Image.file(
                                                File(model.sample!.imageRequestPath!),
                                                fit: BoxFit.fill,
                                                height: double.infinity,
                                                width: double.infinity,
                                              ),
                                            );
                                          });
                                        },
                                        child: Container(
                                          child: Image.file(
                                            File(model.sample!.imageRequestPath!),
                                          fit: BoxFit.fill,
                                          ),
                                        ),
                                      ):model.isConnected?Image.network('https://upload.wikimedia.org/wikipedia/commons/6/62/%22No_Image%22_placeholder.png') :
                                          SizedBox()
                                  ),
                                  SizedBox(height: 10,),
                                  model.sample!.imageResultPath != null ?
                                  GestureDetector(
                                    onTap: (){
                                      showDialog(context: context, builder:(context)
                                      {
                                        return AlertDialog(
                                          content: Image.file(
                                            File(model.sample!.imageResultPath!),
                                            fit: BoxFit.fill,
                                            height: double.infinity,
                                            width: double.infinity,
                                          ),
                                        );
                                      });
                                    },
                                    child: Container(
                                        width: double.infinity,
                                        height: 200,
                                        child: Image.file(File(model.sample!.imageResultPath!)
                                        ,fit: BoxFit.fill,
                                        )),
                                  ) :model.isConnected?
                                  Image.network('https://upload.wikimedia.org/wikipedia/commons/6/62/%22No_Image%22_placeholder.png'):
                                  SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                        model.sample!.finishedAt!=null?SizedBox():TextButton(
                            onPressed:
                                () async {
                              showDialog(context: context, builder:(context){
                                return AlertDialog(
                                  content: SampleOperationPage(sampleNumber:model.sample!.sampleNumber,sampleId: model.sample!.sampleId,
                                      sending:model.sample!.sentAt==null? true:false),
                                );
                              });
                            },
                            child: Text(model.sample!.sentAt==null?'send sample'.toUpperCase():'finish sample'.toUpperCase())),
                      ],
                    ),
                  ),
                );
          }
        })
      );
  }
  void deleteSample(SampleBloc model,BuildContext context,int sampleId){
    showDialog(context: context, builder:(context){
      return
        AlertDialog(
          content: SizedBox(
            width: 500,
            height: 250,
            child: Column(
              children: [
                Text('do you want to delete this sample? '
                    ,
                    style: customStyle(
                        size: 20,
                        weight: FontWeight.bold,
                        color: Colors.red
                    )
                ),
                const SizedBox(height:10,),
                Expanded(
                  child: Text('warning!!!!!\nthis will delete all data for this sample! you can update instead of deleting  continue? ',
                      style: customStyle(
                          size: 20,
                          weight: FontWeight.normal,
                          color: Colors.red
                      )
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    appButton(
                      width: 100,
                      onPressed:(){
                        try {
                          model.deleteSample(sampleId);
                          model.changeIsDeleted();
                          Navigator.pop(context);
                        }catch(e)
                        {
                          viewSnackBar(context,Text(e.toString()));
                        }
                        },text:'yes',
                      style: customStyle(
                          size: 20,
                          weight: FontWeight.normal),),
                    const Expanded(child: SizedBox()),
                    appButton(
                        width: 100,
                        onPressed:(){
                          Navigator.pop(context);

                        },text:'cancel',style: customStyle(
                        size: 20,
                        weight: FontWeight.normal)),
                  ],
                )
              ],
            ),
          ),
        );
    }).then((value){
      if(model.isDeleted) {
        Navigator.pop(context);
      }
    });

  }
}
class SampleOperationPage extends StatelessWidget   {
  const SampleOperationPage({Key? key,required this.sampleNumber,required this.sampleId,required this.sending}) : super(key: key);
 final bool sending;
final int sampleId;
final String sampleNumber;
  @override
  Widget build(BuildContext context) {
    var formKey=GlobalKey<FormState>();
    final TextEditingController nameController=TextEditingController();
    final TextEditingController dateController=TextEditingController(text: MyDate.dateToString(DateTime.now()));
    final TextEditingController resultController=TextEditingController();
    String? imagePath;
    return  BlocProvider(
      create: (context)=>SampleBloc(),
      child: BlocConsumer<SampleBloc,AppStates>(
        listener: (context,state){},
        builder:(context,state) {
          SampleBloc model=SampleBloc.instance(context);
          return Container(
          height: 450,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(sending?'send sample page':'finish sample'),
                  SizedBox(height: 10,),
                  appTextFormField(label:sending?'sent by':'finished by', hint: 'enter name',controller: nameController),
                  SizedBox(height: 10,),
                  appTextFormField(label:'date', hint:'tap to enter date',controller: dateController,
                      onTap: ()async{
                        DateTime? doneDate=await getDatePicker(context,DateTime.now());
                        if(doneDate!=null)
                        {
                          dateController.text=MyDate.dateToString(doneDate);
                        }
                      }
                  ),
                  SizedBox(height: 10,),
                  sending?SizedBox():appTextFormField(validator: (value)
                  {
                    if(value!.isEmpty)
                      return 'you must enter result blood group';
                    return null;
                  },label:'result', hint:'enter result blood group',controller: resultController),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      IconButton(onPressed:(){
                          Helper.getPhoto(sending? sampleNumber:'r_$sampleNumber',ImageSource.camera).then((value){
                            imagePath=value;
                          });
                      }, icon:Icon(Icons.camera_alt_outlined)),
                      IconButton(onPressed:(){
                        Helper.getPhoto(sending? sampleNumber:'r_$sampleNumber',
          ImageSource.gallery).then((value) {
            imagePath=value;
                        }
                        );
                      }, icon:Icon(Icons.photo)),
                    ],
                  ),
                  appButton(text:sending?'send sample':'finish sample', onPressed:(){
                    if(sending)
                    {
                      if(nameController.text.isEmpty)
                      model.sentSample(sampleId, sentAt:dateController.text,
                          imageRequestPath: imagePath);
                      else
                      {
                        model.sentSample(sampleId, sentAt:dateController.text,
                            sentBy: nameController.text,imageRequestPath: imagePath);
                      }
                      Navigator.pop(context);
                    }
                    else
                    {
                      if(formKey.currentState!.validate())
                      {
                        if(nameController.text.isEmpty) {
                          model.finishSample(
                              sampleId, finishedAt: dateController.text,
                              actualResult: resultController.text,
                              imageResultPath: imagePath);
                        }
                        else
                        {
                          model.finishSample(sampleId, finishedAt: dateController.text,
                              actualResult: resultController.text,
                              finishedBy: nameController.text,
                              imageResultPath: imagePath);
                        }
                        Navigator.pop(context);
                      }
                    }
                  }),
                  SizedBox(height: 10,),
                  appButton(text:'cancel', onPressed:(){
                    Navigator.pop(context);
                  })
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
