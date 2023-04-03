import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
class Helper
{
  static  Future<String?> getPhoto(String fileName,ImageSource source)async
  {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      String? photoPath;
      XFile? photoFile = await ImagePicker().pickImage(source: source) ;
      if(photoFile!=null){
         photoPath = '$path/$fileName.png';
         photoFile.saveTo(photoPath);
      }
      return photoPath;
    }
    catch(e)
    {
      print(e.toString());
      return e.toString();
    }
  }
}