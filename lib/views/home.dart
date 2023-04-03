import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/states.dart';
import '../helpers/const_widgets.dart';
import '../helpers/constants.dart';
import '../helpers/date.dart';
import '../models/rcrl.dart';
class HomePage      extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create:(context)=>HomeBloc(),
        child: BlocConsumer<HomeBloc,AppStates>(
          listener:(context,state){} ,
          builder:(context,state) {
            HomeBloc model=HomeBloc.instance(context);
            model.fillSamplesList();
            // if(model.oldest) {
            //   model.setReagentsMap();
            // }
            // if(model.newest)
            // {
            //   model.setReagentsMap(order1: '$reagentIdColumn desc');
            // }
            // if(model.name)
            // {
            //   model.setReagentsMap(order1: reagentNameColumn );
            // }
            // if(model.category)
            // {
            //   model.setReagentsMap(order1: reagentCategoryColumn ,order2:reagentSubCategoryColumn );
            // }
            return Scaffold(
              appBar: AppBar(title: const Text('home page'),),
              body:
              Padding(
                padding: const EdgeInsets.only(top:10,left: 8,right: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible:true,
                          child: searchContainer(() {
                            Navigator.pushNamed(context,searchPageRoute);
                          },true),
                        ),
                        SizedBox(height: 10,),
                        // Visibility(
                        //     visible:model.isVisible,
                        //     child: SizedBox(height: 10,)),
                        // sortList(isVisible:model.isVisible, onTap: (){
                        //   model.showSorting();
                        // }),
                        // model.isSorted?
                        // Card(
                        //   child: SizedBox(
                        //     width: 120,
                        //     child: Column(
                        //       children: [
                        //         sortedContainer(onTap: (){
                        //           model.oldestSorting();
                        //
                        //         }, text: 'oldest',isChecked: model.oldest),
                        //         const SizedBox(height: 5,),
                        //         sortedContainer(onTap: (){
                        //           model.newestSorting();
                        //         }, text:'newest',isChecked: model.newest),
                        //         const SizedBox(height: 5,),
                        //         sortedContainer(onTap: (){
                        //           model.nameSorting();
                        //         }, text:'name',isChecked:model.name),
                        //         const SizedBox(height: 5,),
                        //         sortedContainer(onTap: (){
                        //           model.categorySorting();
                        //         }, text: 'category',
                        //             isChecked: model.category)
                        //       ],
                        //     ),
                        //   ),
                        // ):const SizedBox(width: 0,),
                        model.notFinishedSamples.length<=0?Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('no samples found click button to add sample'),
                            ],
                          ),
                        ):Expanded(
                          child: NotificationListener<UserScrollNotification>(
                              onNotification: (notification){
                                // if(notification.direction==ScrollDirection.reverse)
                                // {
                                //   model.changeScroll();
                                // }
                                // else if(notification.direction==ScrollDirection.forward)
                                // {
                                //   model.changeScroll();
                                // }
                                return true;
                              },
                              child:
                              sampleListView(samples: model.notFinishedSamples)
                          ),
                        )
                      ]
                  ),
                ),
              )
              ,
              floatingActionButton: Visibility(
                visible:true,
                child: FloatingActionButton(
                    elevation: 20,
                    onPressed: (){
                      showDialog(context: context, builder:(ctx){
                        return AlertDialog(content: AddSampleView());
                      }).then((value){
                        model.fillSamplesList();
                      });
                    },child:  const CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add,color: Colors.blue,))),
              ),
            );
          },
        ),
      );
  }
  Widget searchContainer(void Function() onTap,bool isVisible)
  {
    return Visibility(
      visible:isVisible,
      child:
      GestureDetector(
        onTap: onTap
        ,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[350],
            border: Border.all(color:Colors.black54),
          ),
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: const [
              Icon(Icons.search),
              SizedBox(width: 50,),
              Text('click to search'),

            ],
          ),
        ),
      ),
    );
  }
  Widget sortList({required bool isVisible,required void Function() onTap})
  {
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        onTap:
        onTap
        ,
        child: Row(
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text('sort by'),
              Icon(Icons.arrow_drop_down)
            ]),
      ),
    );
  }
  Widget sortedContainer({required void Function() onTap,required String text,
    bool isChecked=true})
  {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 5),
        child: Row(
          children: [
            Expanded(
              child: Text(text,style: customStyle(
                  weight: FontWeight.normal,
                  size: 20
              )),
            ),
            // const SizedBox(width: 10,),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child:isChecked?const Icon(Icons.check):null,
            )
          ],
        ),
      ),
    );
  }
// Expanded(
// child:
}
class AddSampleView extends StatelessWidget {
   AddSampleView({Key? key}) : super(key: key);
   final formKey=GlobalKey<FormState>();
   final TextEditingController sampleNameController=TextEditingController();
   final TextEditingController doneByController=TextEditingController();
   final TextEditingController doneDateController=TextEditingController(text: MyDate.dateToString(DateTime.now()));
   final TextEditingController resultController=TextEditingController();
   @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>HomeBloc(),
      child: BlocConsumer<HomeBloc,AppStates>(
        listener: (context,state){},
        builder:(context,state)=> Container(
          height: 450,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('add sample page'),
                  SizedBox(height: 10,),
                  appTextFormField(
                      validator: (value)
                      {
                        if(value!.isEmpty)
                          return 'you must enter sample number';
                        return null;
                      },
                      label:'sample number', hint: 'enter sample number',controller: sampleNameController),
                  SizedBox(height: 10,),
                  appTextFormField(validator: (value)
                  {
                    if(value!.isEmpty)
                      return 'you must enter name of person whose sample done by';
                    return null;
                  },label:'done by ', hint:'enter name',controller: doneByController),
                  SizedBox(height: 10,),
                  appTextFormField(label:'done at', hint:'tap to enter date',controller: doneDateController,
                  onTap: ()async{
                    DateTime? doneDate=await getDatePicker(context,DateTime.now());
                    if(doneDate!=null)
                    {
                      doneDateController.text=MyDate.dateToString(doneDate);
                    }
                  }
                  ),
                  SizedBox(height: 10,),
                  appTextFormField(validator: (value)
                  {
                    if(value!.isEmpty)
                      return 'you must enter expected blood group';
                    return null;
                  },label:'result', hint:'enter expected blood group',controller: resultController),
                  SizedBox(height: 30,),
                  appButton(text:'add sample', onPressed:(){
                    if(formKey.currentState!.validate())
                    {
                      RcrlModel rcrlSample=RcrlModel(sampleId:1,
                          sampleNumber:sampleNameController.text, doneAt:doneDateController.text,
                          doneBy: doneByController.text, expectedResult:resultController.text);
                      HomeBloc.instance(context).addSample(rcrlSample);
                      Navigator.pop(context);
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
        ),
      ),
    );
  }
}




