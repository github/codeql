using  System;
using System.Globalization;
public class Example
{
   public static void Main()
   {
      var cal = new JapaneseCalendar();
      // constructing date using current era 
      var dat = cal.ToDateTime(2, 1, 2, 0, 0, 0, 0);
      Console.WriteLine($"{dat:s}");
      // constructing date using current era 
      dat = new DateTime(2, 1, 2, cal);
      Console.WriteLine($"{dat:s}");
   }
}
// Output with the Heisei era current:
//      1990-01-02T00:00:00
//      1990-01-02T00:00:00
// Output with the new era current:
//      2020-01-02T00:00:00
//      2020-01-02T00:00:00