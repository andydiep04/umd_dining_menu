import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DataController extends GetxController{
  List<String> name = [];
  List<String> date = [];
  List<String> location = [];
  List<String> type = [];
  List<String> uri = [];


  void addName(String text){
    name.add(text);
    update();
  }

  void addDate(String text){
    date.add(text);
    update();
  }

  void addLocation(String text){
    location.add(text);
    update();
  }

  void addType(String text){
    type.add(text);
    update();
  }

  void addUri(String text){
    uri.add(text);
    update();
  }
}