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
            this.Start = new DateTime(now.Year - 1, now.Month, now.Day, 0, 0, 0, DateTimeKind.Utc); // $ Alert

            var endYear = now.Year + 1; // $ Source
            // BAD
            this.End = new DateTime(endYear, now.Month, now.Day, 0, 0, 1, DateTimeKind.Utc); // $ Alert

            // GOOD
            this.Start = now.AddYears(-1).Date;
        }

        private void Test(int year, int month, int day)
        {
            // BAD (arithmetic operation from StartTest)
            this.Start = new DateTime(year, month, day); // $ Alert
        }

        public void StartTest()
        {
            var now = DateTime.UtcNow;
            // flows into Test (source for bug)
            Test(now.Year - 1, now.Month, now.Day); // $ Source
        }

        public void StartTestFP()
        {
            var now = DateTime.UtcNow;
            Test(1900 + 80, now.Month, now.Day);
        }
    }
}
