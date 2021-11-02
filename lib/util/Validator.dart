

class Validator {


  static bool isValid(String alarmName, int hour, int minute){
    if(alarmName.isNotEmpty && hour != null && minute != null) {
      return true;
    } else {
      return false;
    }
  }





}