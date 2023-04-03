import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/states.dart';
import '../helpers/const_widgets.dart';
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create:(context)=>HomeBloc(),
        child: BlocConsumer<HomeBloc,AppStates>(
          listener:(context,state){} ,
          builder:(context,state) {
            HomeBloc model=HomeBloc.instance(context);
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
                          child:appTextFormField(label: 'search', hint:'enter searched word',
                          onChanged: (value){
                            model.fillSearchedSamplesList(value!);
                          }
                          ),
                        ),
                        SizedBox(height: 10,),
                        // model.notFinishedSamples.length<=0?SizedBox(
                        //   height: double.infinity,
                        //   child: Center(child: Text('enter word to start search'),),
                        // ):
                  Expanded(
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
                              sampleListView(samples: model.searchedSamples)
                          ),
                        )
                      ]
                  ),
                ),
              )


            );
          },
        ),
      );
  }
}
