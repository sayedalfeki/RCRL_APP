import 'package:flutter/material.dart';
import '../helpers/constants.dart';
import '../views/home.dart';
import '../views/sample.dart';
import '../views/search.dart';
import '../views/update_view.dart';
import 'views/app_view.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Helper.getPhoto('sayed1',ImageSource.gallery).then((value) => print(value));
   // XFile? file=await  ImagePicker().pickImage(source: ImageSource.gallery,) ;
   //
   //  print(file!.path);
    // RcrlModel rcrlModel= RcrlModel(sampleId: 1, sampleNumber:'3', doneAt:'2023-03-20',
    //     doneBy:'ghada', expectedResult:'ABpos');
    // SampleDataBase sampleDataBase=SampleDataBase();
    //  //sampleDataBase.insert(rcrlModel);
    // //sampleDataBase.delete(1);
    // //sampleDataBase.updateSending(2, sentAt:'2023-03-21');
    // //sampleDataBase.updateFinishing(1, finishedAt:'2023-03-19', actualResult:'Apos');
    // List<RcrlModel> models=await sampleDataBase.getSearchedSamples('');
    // for(var model in models)
    // print('sample number:${model.sampleNumber} \ndone at: ${model.doneAt}\n done by: ${model.doneBy}\n sent at :${model.sentAt}'
    //     '\n sent by: ${model.sentBy}\n finished at :${model.finishedAt}\n finished by: ${model.finishedBy}\n expected result ${model.expectedResult}'
    //     '\n actual result ${model.actualResult}\n request path:${model.imageRequestPath} \n'
    //     'result path: ${model.imageResultPath}');












    runApp(MaterialApp(
      // theme: ThemeData(
      //   appBarTheme: AppBarTheme(
      //     color: Colors.white,
      //     elevation: 0,
      //     titleTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
      //   )
      // ),
      debugShowCheckedModeBanner: false,
      initialRoute:homePageRoute,
      routes: {
        homePageRoute:(con)=>VideoApp(),
         samplePageRoute:(con)=>SampleDetailsPage(),
         searchPageRoute:(con)=>SearchPage(),
        updatePageRoute:(con)=>UpdateSampleView()
      },
    ));
  } catch (e) {
    print(e.toString());
  }
}

