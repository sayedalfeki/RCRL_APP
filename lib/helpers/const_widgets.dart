import 'package:flutter/material.dart';
import '../models/rcrl.dart';
import 'constants.dart';
import 'date.dart';


TextStyle customStyle({Color color=Colors.blue,double size=25,FontWeight weight=FontWeight.bold})=>TextStyle(
  color: color,
  fontSize: size,
  fontWeight:weight,
);
Widget appButton({Color backgroundColor=Colors.white,required String text,TextStyle? style,
  required void Function() onPressed,double height=50,double width=200})
{

  return  Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black)
    ),
    child: TextButton(onPressed: onPressed,
        child:  Text(text.toUpperCase(),
          style: style,)),
  );

}
Widget appTextFormField({String? Function(String?)? validator,void Function()? onTap,
  void Function(String?)? onChanged,TextEditingController? controller,bool isNum=false,
  required String label,required String hint,void Function(String)? onSubmit
})
{
  return Container(
    padding: const EdgeInsets.only(left: 10,right: 10),
    child: TextFormField(

      keyboardAppearance:Brightness.light ,
      validator: validator,
      onFieldSubmitted: onSubmit,
      onTap:onTap ,
      onChanged: onChanged,
      controller: controller,
      keyboardType:isNum?TextInputType.number:TextInputType.text ,
      decoration: InputDecoration(
          border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          labelText: label,
          hintText: hint
      ),
    ),
  );
}
Future<DateTime?> getDatePicker(BuildContext context,DateTime initialDate)async
{
  return await showDatePicker(context: context, initialDate:initialDate,
      lastDate:DateTime(2050), firstDate:DateTime(2022));
}
viewSnackBar(BuildContext context,Widget child,{int duration=2000}) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(milliseconds: duration),
          content: child));
}
Widget makeProgressPar()
{
  return Center(
    child: CircularProgressIndicator(),
  );
}
sampleListView({required List<RcrlModel> samples})
{
  return ListView.builder(
    itemBuilder:(context,index) {
      bool isAlarm=samples[index].finishedAt==null&&MyDate.getDiffDate(old_date: MyDate.toDate(samples[index].doneAt),
          new_date:DateTime.now())>=7?true:false;
      return GestureDetector(
           onTap:
          (){
            Navigator.pushNamed(context,samplePageRoute,
                arguments: {
                  sampleIdKey:samples[index].sampleId
                }
            );
          },
          child: Card(
            elevation: 20,
            child: Container(
              color:samples[index].finishedAt==null&&MyDate.getDiffDate(old_date: MyDate.toDate(samples[index].doneAt),
                  new_date:DateTime.now())>=7?Colors.red:Colors.white,
              padding: const EdgeInsets.only(left: 10,right: 10),
              height: 200,
              child: Column(
                children: [
                  sampleRow(isAlarm:isAlarm,text1:'sample number : ', text2:samples[index].sampleNumber,width: 10,size:15),
                  SizedBox(height: 5,),
                  sampleRow(isAlarm:isAlarm,text1:'done by : ', text2: samples[index].doneBy),
                  SizedBox(height: 5,),
                  sampleRow(isAlarm:isAlarm,text1: 'done at : ', text2:samples[index].doneAt),
                  SizedBox(height: 5,),
                  sampleRow(isAlarm:isAlarm,text1:'sent at : ', text2:samples[index].sentAt??'not sent yet'),
                  SizedBox(height: 5,),
                  sampleRow(isAlarm:isAlarm,text1:'finished at : ', text2:samples[index].finishedAt??'not finished yet',size: 20),
                ],
              ),
            ),
          ),
        );
    },
    itemCount: samples.length,
  );
}
sampleRow({required String text1,required String text2,double size=25,isAlarm=false,double width=30})
{
  return  Container(
    width: double.infinity,
    child: Row(
      textBaseline: TextBaseline.alphabetic,
       mainAxisSize: MainAxisSize.min,
       //mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text1,style: customStyle(
          size: size,
          color:isAlarm?Colors.black:Colors.blue
        ),),
        SizedBox(width: width,),
        Text(text2
          ,style: customStyle(
              color:isAlarm?Colors.white:Colors.teal
          ), ),

      ],
    ),
  );
}
