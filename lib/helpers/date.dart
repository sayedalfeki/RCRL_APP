class MyDate
{
  static String dateToString(DateTime t) {
    int year=t.year;
    int month=t.month;
    int day=t.day<10?0+t.day:t.day;
    String sMonth=month<10?'0$month':'$month';
    String sDay=day<10?'0$day':'$day';

    return '$year-$sMonth-$sDay';
  }

 static DateTime toDate(String date)=> DateTime.parse(date);
 static int getDiffDate({required DateTime old_date,required DateTime new_date})=> new_date.difference(old_date).inDays;
}