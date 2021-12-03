using System;

namespace LeapYear
{
    public class PipelineProperties
    {
        public DateTime Start;
        public DateTime End;
        public PipelineProperties()
        {
            var now = DateTime.UtcNow;
            // BAD
            this.Start = new DateTime(now.Year - 1, now.Month, now.Day, 0, 0, 0, DateTimeKind.Utc);

            var endYear = now.Year + 1;
            // BAD
            this.End = new DateTime(endYear, now.Month, now.Day, 0, 0, 1, DateTimeKind.Utc);

            // GOOD
            this.Start = now.AddYears(-1).Date;
        }

        private void Test(int year, int month, int day)
        {
            // BAD (arithmetic operation from StartTest)
            this.Start = new DateTime(year, month, day);
        }

        public void StartTest()
        {
            var now = DateTime.UtcNow;
            // flows into Test (source for bug)
            Test(now.Year - 1, now.Month, now.Day);
        }

        public void StartTestFP()
        {
            var now = DateTime.UtcNow;
            Test(1900 + 80, now.Month, now.Day);
        }
    }
}
