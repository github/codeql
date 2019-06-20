using System;
using System.Collections.Generic;
using System.Globalization;

namespace JapaneseDates
{
    class Program
    {
        static void Main(string[] args)
        {
            // BAD: hard-coded era start date
            var henseiStart = new DateTime(1989, 1, 8);

            // BAD: hard-coded era start dates, list
            List<DateTime> listOfEraStart = new List<DateTime> { new DateTime(1989, 1, 8) };

            // BAD: hardcoded era name
            string currentEra = "Heisei";

            DateTimeOffset dateNow = DateTimeOffset.Now;

            DateTimeOffset dateThisEra = new DateTimeOffset(1989, 1, 8, 0, 0, 0, 0, TimeSpan.Zero);

            CultureInfo japaneseCulture = CultureInfo.GetCultureInfo("ja-JP");

            JapaneseCalendar jk = new JapaneseCalendar();

            // BAD: datetime is created from constant year in the current era, and the result will change with era change
            var datejkCurrentEra  = jk.ToDateTime(32, 2, 1, 9, 9, 9, 9);
            Console.WriteLine("Date for datejkCurrentEra {0} and year {1}",  datejkCurrentEra.ToString(japaneseCulture), jk.GetYear (datejkCurrentEra));

            // BAD: datetime is created from constant year in the current era, and the result will change with era change
            var datejk  = jk.ToDateTime(32, 2, 1, 9, 9, 9, 9, 0);
            Console.WriteLine("Date for jk {0} and year {1}", datejk.ToString(japaneseCulture), jk.GetYear (datejk));

            // OK: datetime is created from constant year in the specific era, and the result will not change with era change
            var datejk1  = jk.ToDateTime(32, 2, 1, 9, 9, 9, 9, 4);
            Console.WriteLine("Date for jk {0} and year {1}", datejk1.ToString(japaneseCulture), jk.GetYear (datejk1));

            // OK: year is not hard-coded, i.e. it may be updated
            var datejk0 = jk.ToDateTime(jk.GetYear(datejk), 2, 1, 9, 9, 9, 9);
            Console.WriteLine("Date for jk0 {0} and year {1}", datejk0, jk.GetYear(datejk0));

            // BAD: hard-coded year conversion
            int realYear = 1988 + jk.GetYear(datejk);
            Console.WriteLine("Which converts to year {0}", realYear);

            // BAD: creating DateTime using specified Japanese era date. This may yield a different date when era changes
            DateTime val = new DateTime(32, 2, 1, new JapaneseCalendar());
            Console.WriteLine("DateTime from constructor {0}", val);

            // OK: variable data for Year, not necessarily hard-coded and can come from adjusted source
            DateTime val1 = new DateTime(jk.GetYear(datejk), 2, 1, new JapaneseCalendar());
            Console.WriteLine("DateTime from constructor {0}", val);
        }
    }
}
