// This file contains auto-generated code.

namespace Microsoft
{
    namespace VisualBasic
    {
        // Generated from `Microsoft.VisualBasic.AppWinStyle` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum AppWinStyle
        {
            Hide,
            MaximizedFocus,
            MinimizedFocus,
            MinimizedNoFocus,
            NormalFocus,
            NormalNoFocus,
        }

        // Generated from `Microsoft.VisualBasic.CallType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum CallType
        {
            Get,
            Let,
            Method,
            Set,
        }

        // Generated from `Microsoft.VisualBasic.Collection` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Collection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            int System.Collections.IList.Add(object value) => throw null;
            public void Add(object Item, string Key = default(string), object Before = default(object), object After = default(object)) => throw null;
            public void Clear() => throw null;
            void System.Collections.IList.Clear() => throw null;
            public Collection() => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            public bool Contains(string Key) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            int System.Collections.ICollection.Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            public object this[int Index] { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
            public object this[object Index] { get => throw null; }
            public object this[string Key] { get => throw null; }
            public void Remove(int Index) => throw null;
            void System.Collections.IList.Remove(object value) => throw null;
            public void Remove(string Key) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
        }

        // Generated from `Microsoft.VisualBasic.ComClassAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ComClassAttribute : System.Attribute
        {
            public string ClassID { get => throw null; }
            public ComClassAttribute() => throw null;
            public ComClassAttribute(string _ClassID) => throw null;
            public ComClassAttribute(string _ClassID, string _InterfaceID) => throw null;
            public ComClassAttribute(string _ClassID, string _InterfaceID, string _EventId) => throw null;
            public string EventID { get => throw null; }
            public string InterfaceID { get => throw null; }
            public bool InterfaceShadows { get => throw null; set => throw null; }
        }

        // Generated from `Microsoft.VisualBasic.CompareMethod` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum CompareMethod
        {
            Binary,
            Text,
        }

        // Generated from `Microsoft.VisualBasic.Constants` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Constants
        {
            public const Microsoft.VisualBasic.MsgBoxResult vbAbort = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbAbortRetryIgnore = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbApplicationModal = default;
            public const Microsoft.VisualBasic.FileAttribute vbArchive = default;
            public const Microsoft.VisualBasic.VariantType vbArray = default;
            public const string vbBack = default;
            public const Microsoft.VisualBasic.CompareMethod vbBinaryCompare = default;
            public const Microsoft.VisualBasic.VariantType vbBoolean = default;
            public const Microsoft.VisualBasic.VariantType vbByte = default;
            public const Microsoft.VisualBasic.MsgBoxResult vbCancel = default;
            public const string vbCr = default;
            public const string vbCrLf = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbCritical = default;
            public const Microsoft.VisualBasic.VariantType vbCurrency = default;
            public const Microsoft.VisualBasic.VariantType vbDate = default;
            public const Microsoft.VisualBasic.VariantType vbDecimal = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbDefaultButton1 = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbDefaultButton2 = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbDefaultButton3 = default;
            public const Microsoft.VisualBasic.FileAttribute vbDirectory = default;
            public const Microsoft.VisualBasic.VariantType vbDouble = default;
            public const Microsoft.VisualBasic.VariantType vbEmpty = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbExclamation = default;
            public const Microsoft.VisualBasic.TriState vbFalse = default;
            public const Microsoft.VisualBasic.FirstWeekOfYear vbFirstFourDays = default;
            public const Microsoft.VisualBasic.FirstWeekOfYear vbFirstFullWeek = default;
            public const Microsoft.VisualBasic.FirstWeekOfYear vbFirstJan1 = default;
            public const string vbFormFeed = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbFriday = default;
            public const Microsoft.VisualBasic.DateFormat vbGeneralDate = default;
            public const Microsoft.VisualBasic.CallType vbGet = default;
            public const Microsoft.VisualBasic.FileAttribute vbHidden = default;
            public const Microsoft.VisualBasic.AppWinStyle vbHide = default;
            public const Microsoft.VisualBasic.VbStrConv vbHiragana = default;
            public const Microsoft.VisualBasic.MsgBoxResult vbIgnore = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbInformation = default;
            public const Microsoft.VisualBasic.VariantType vbInteger = default;
            public const Microsoft.VisualBasic.VbStrConv vbKatakana = default;
            public const Microsoft.VisualBasic.CallType vbLet = default;
            public const string vbLf = default;
            public const Microsoft.VisualBasic.VbStrConv vbLinguisticCasing = default;
            public const Microsoft.VisualBasic.VariantType vbLong = default;
            public const Microsoft.VisualBasic.DateFormat vbLongDate = default;
            public const Microsoft.VisualBasic.DateFormat vbLongTime = default;
            public const Microsoft.VisualBasic.VbStrConv vbLowerCase = default;
            public const Microsoft.VisualBasic.AppWinStyle vbMaximizedFocus = default;
            public const Microsoft.VisualBasic.CallType vbMethod = default;
            public const Microsoft.VisualBasic.AppWinStyle vbMinimizedFocus = default;
            public const Microsoft.VisualBasic.AppWinStyle vbMinimizedNoFocus = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbMonday = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbMsgBoxHelp = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbMsgBoxRight = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbMsgBoxRtlReading = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbMsgBoxSetForeground = default;
            public const Microsoft.VisualBasic.VbStrConv vbNarrow = default;
            public const string vbNewLine = default;
            public const Microsoft.VisualBasic.MsgBoxResult vbNo = default;
            public const Microsoft.VisualBasic.FileAttribute vbNormal = default;
            public const Microsoft.VisualBasic.AppWinStyle vbNormalFocus = default;
            public const Microsoft.VisualBasic.AppWinStyle vbNormalNoFocus = default;
            public const Microsoft.VisualBasic.VariantType vbNull = default;
            public const string vbNullChar = default;
            public const string vbNullString = default;
            public const Microsoft.VisualBasic.MsgBoxResult vbOK = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbOKCancel = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbOKOnly = default;
            public const Microsoft.VisualBasic.VariantType vbObject = default;
            public const int vbObjectError = default;
            public const Microsoft.VisualBasic.VbStrConv vbProperCase = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbQuestion = default;
            public const Microsoft.VisualBasic.FileAttribute vbReadOnly = default;
            public const Microsoft.VisualBasic.MsgBoxResult vbRetry = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbRetryCancel = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbSaturday = default;
            public const Microsoft.VisualBasic.CallType vbSet = default;
            public const Microsoft.VisualBasic.DateFormat vbShortDate = default;
            public const Microsoft.VisualBasic.DateFormat vbShortTime = default;
            public const Microsoft.VisualBasic.VbStrConv vbSimplifiedChinese = default;
            public const Microsoft.VisualBasic.VariantType vbSingle = default;
            public const Microsoft.VisualBasic.VariantType vbString = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbSunday = default;
            public const Microsoft.VisualBasic.FileAttribute vbSystem = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbSystemModal = default;
            public const string vbTab = default;
            public const Microsoft.VisualBasic.CompareMethod vbTextCompare = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbThursday = default;
            public const Microsoft.VisualBasic.VbStrConv vbTraditionalChinese = default;
            public const Microsoft.VisualBasic.TriState vbTrue = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbTuesday = default;
            public const Microsoft.VisualBasic.VbStrConv vbUpperCase = default;
            public const Microsoft.VisualBasic.TriState vbUseDefault = default;
            public const Microsoft.VisualBasic.FirstWeekOfYear vbUseSystem = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbUseSystemDayOfWeek = default;
            public const Microsoft.VisualBasic.VariantType vbUserDefinedType = default;
            public const Microsoft.VisualBasic.VariantType vbVariant = default;
            public const string vbVerticalTab = default;
            public const Microsoft.VisualBasic.FileAttribute vbVolume = default;
            public const Microsoft.VisualBasic.FirstDayOfWeek vbWednesday = default;
            public const Microsoft.VisualBasic.VbStrConv vbWide = default;
            public const Microsoft.VisualBasic.MsgBoxResult vbYes = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbYesNo = default;
            public const Microsoft.VisualBasic.MsgBoxStyle vbYesNoCancel = default;
        }

        // Generated from `Microsoft.VisualBasic.ControlChars` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ControlChars
        {
            public const System.Char Back = default;
            public ControlChars() => throw null;
            public const System.Char Cr = default;
            public const string CrLf = default;
            public const System.Char FormFeed = default;
            public const System.Char Lf = default;
            public const string NewLine = default;
            public const System.Char NullChar = default;
            public const System.Char Quote = default;
            public const System.Char Tab = default;
            public const System.Char VerticalTab = default;
        }

        // Generated from `Microsoft.VisualBasic.Conversion` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Conversion
        {
            public static object CTypeDynamic(object Expression, System.Type TargetType) => throw null;
            public static TargetType CTypeDynamic<TargetType>(object Expression) => throw null;
            public static string ErrorToString() => throw null;
            public static string ErrorToString(int ErrorNumber) => throw null;
            public static System.Decimal Fix(System.Decimal Number) => throw null;
            public static double Fix(double Number) => throw null;
            public static float Fix(float Number) => throw null;
            public static int Fix(int Number) => throw null;
            public static System.Int64 Fix(System.Int64 Number) => throw null;
            public static object Fix(object Number) => throw null;
            public static System.Int16 Fix(System.Int16 Number) => throw null;
            public static string Hex(System.Byte Number) => throw null;
            public static string Hex(int Number) => throw null;
            public static string Hex(System.Int64 Number) => throw null;
            public static string Hex(object Number) => throw null;
            public static string Hex(System.SByte Number) => throw null;
            public static string Hex(System.Int16 Number) => throw null;
            public static string Hex(System.UInt32 Number) => throw null;
            public static string Hex(System.UInt64 Number) => throw null;
            public static string Hex(System.UInt16 Number) => throw null;
            public static System.Decimal Int(System.Decimal Number) => throw null;
            public static double Int(double Number) => throw null;
            public static float Int(float Number) => throw null;
            public static int Int(int Number) => throw null;
            public static System.Int64 Int(System.Int64 Number) => throw null;
            public static object Int(object Number) => throw null;
            public static System.Int16 Int(System.Int16 Number) => throw null;
            public static string Oct(System.Byte Number) => throw null;
            public static string Oct(int Number) => throw null;
            public static string Oct(System.Int64 Number) => throw null;
            public static string Oct(object Number) => throw null;
            public static string Oct(System.SByte Number) => throw null;
            public static string Oct(System.Int16 Number) => throw null;
            public static string Oct(System.UInt32 Number) => throw null;
            public static string Oct(System.UInt64 Number) => throw null;
            public static string Oct(System.UInt16 Number) => throw null;
            public static string Str(object Number) => throw null;
            public static int Val(System.Char Expression) => throw null;
            public static double Val(object Expression) => throw null;
            public static double Val(string InputStr) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.DateAndTime` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class DateAndTime
        {
            public static System.DateTime DateAdd(Microsoft.VisualBasic.DateInterval Interval, double Number, System.DateTime DateValue) => throw null;
            public static System.DateTime DateAdd(string Interval, double Number, object DateValue) => throw null;
            public static System.Int64 DateDiff(Microsoft.VisualBasic.DateInterval Interval, System.DateTime Date1, System.DateTime Date2, Microsoft.VisualBasic.FirstDayOfWeek DayOfWeek = default(Microsoft.VisualBasic.FirstDayOfWeek), Microsoft.VisualBasic.FirstWeekOfYear WeekOfYear = default(Microsoft.VisualBasic.FirstWeekOfYear)) => throw null;
            public static System.Int64 DateDiff(string Interval, object Date1, object Date2, Microsoft.VisualBasic.FirstDayOfWeek DayOfWeek = default(Microsoft.VisualBasic.FirstDayOfWeek), Microsoft.VisualBasic.FirstWeekOfYear WeekOfYear = default(Microsoft.VisualBasic.FirstWeekOfYear)) => throw null;
            public static int DatePart(Microsoft.VisualBasic.DateInterval Interval, System.DateTime DateValue, Microsoft.VisualBasic.FirstDayOfWeek FirstDayOfWeekValue = default(Microsoft.VisualBasic.FirstDayOfWeek), Microsoft.VisualBasic.FirstWeekOfYear FirstWeekOfYearValue = default(Microsoft.VisualBasic.FirstWeekOfYear)) => throw null;
            public static int DatePart(string Interval, object DateValue, Microsoft.VisualBasic.FirstDayOfWeek DayOfWeek = default(Microsoft.VisualBasic.FirstDayOfWeek), Microsoft.VisualBasic.FirstWeekOfYear WeekOfYear = default(Microsoft.VisualBasic.FirstWeekOfYear)) => throw null;
            public static System.DateTime DateSerial(int Year, int Month, int Day) => throw null;
            public static string DateString { get => throw null; set => throw null; }
            public static System.DateTime DateValue(string StringDate) => throw null;
            public static int Day(System.DateTime DateValue) => throw null;
            public static int Hour(System.DateTime TimeValue) => throw null;
            public static int Minute(System.DateTime TimeValue) => throw null;
            public static int Month(System.DateTime DateValue) => throw null;
            public static string MonthName(int Month, bool Abbreviate = default(bool)) => throw null;
            public static System.DateTime Now { get => throw null; }
            public static int Second(System.DateTime TimeValue) => throw null;
            public static System.DateTime TimeOfDay { get => throw null; set => throw null; }
            public static System.DateTime TimeSerial(int Hour, int Minute, int Second) => throw null;
            public static string TimeString { get => throw null; set => throw null; }
            public static System.DateTime TimeValue(string StringTime) => throw null;
            public static double Timer { get => throw null; }
            public static System.DateTime Today { get => throw null; set => throw null; }
            public static int Weekday(System.DateTime DateValue, Microsoft.VisualBasic.FirstDayOfWeek DayOfWeek = default(Microsoft.VisualBasic.FirstDayOfWeek)) => throw null;
            public static string WeekdayName(int Weekday, bool Abbreviate = default(bool), Microsoft.VisualBasic.FirstDayOfWeek FirstDayOfWeekValue = default(Microsoft.VisualBasic.FirstDayOfWeek)) => throw null;
            public static int Year(System.DateTime DateValue) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.DateFormat` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DateFormat
        {
            GeneralDate,
            LongDate,
            LongTime,
            ShortDate,
            ShortTime,
        }

        // Generated from `Microsoft.VisualBasic.DateInterval` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DateInterval
        {
            Day,
            DayOfYear,
            Hour,
            Minute,
            Month,
            Quarter,
            Second,
            WeekOfYear,
            Weekday,
            Year,
        }

        // Generated from `Microsoft.VisualBasic.DueDate` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum DueDate
        {
            BegOfPeriod,
            EndOfPeriod,
        }

        // Generated from `Microsoft.VisualBasic.ErrObject` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ErrObject
        {
            public void Clear() => throw null;
            public string Description { get => throw null; set => throw null; }
            public int Erl { get => throw null; }
            public System.Exception GetException() => throw null;
            public int HelpContext { get => throw null; set => throw null; }
            public string HelpFile { get => throw null; set => throw null; }
            public int LastDllError { get => throw null; }
            public int Number { get => throw null; set => throw null; }
            public void Raise(int Number, object Source = default(object), object Description = default(object), object HelpFile = default(object), object HelpContext = default(object)) => throw null;
            public string Source { get => throw null; set => throw null; }
        }

        // Generated from `Microsoft.VisualBasic.FileAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum FileAttribute
        {
            Archive,
            Directory,
            Hidden,
            Normal,
            ReadOnly,
            System,
            Volume,
        }

        // Generated from `Microsoft.VisualBasic.FileSystem` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class FileSystem
        {
            public static void ChDir(string Path) => throw null;
            public static void ChDrive(System.Char Drive) => throw null;
            public static void ChDrive(string Drive) => throw null;
            public static string CurDir() => throw null;
            public static string CurDir(System.Char Drive) => throw null;
            public static string Dir() => throw null;
            public static string Dir(string PathName, Microsoft.VisualBasic.FileAttribute Attributes = default(Microsoft.VisualBasic.FileAttribute)) => throw null;
            public static bool EOF(int FileNumber) => throw null;
            public static Microsoft.VisualBasic.OpenMode FileAttr(int FileNumber) => throw null;
            public static void FileClose(params int[] FileNumbers) => throw null;
            public static void FileCopy(string Source, string Destination) => throw null;
            public static System.DateTime FileDateTime(string PathName) => throw null;
            public static void FileGet(int FileNumber, ref System.Array Value, System.Int64 RecordNumber = default(System.Int64), bool ArrayIsDynamic = default(bool), bool StringIsFixedLength = default(bool)) => throw null;
            public static void FileGet(int FileNumber, ref System.DateTime Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref System.ValueType Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref bool Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref System.Byte Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref System.Char Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref System.Decimal Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref double Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref float Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref int Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref System.Int64 Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref System.Int16 Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileGet(int FileNumber, ref string Value, System.Int64 RecordNumber = default(System.Int64), bool StringIsFixedLength = default(bool)) => throw null;
            public static void FileGetObject(int FileNumber, ref object Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static System.Int64 FileLen(string PathName) => throw null;
            public static void FileOpen(int FileNumber, string FileName, Microsoft.VisualBasic.OpenMode Mode, Microsoft.VisualBasic.OpenAccess Access = default(Microsoft.VisualBasic.OpenAccess), Microsoft.VisualBasic.OpenShare Share = default(Microsoft.VisualBasic.OpenShare), int RecordLength = default(int)) => throw null;
            public static void FilePut(int FileNumber, System.Array Value, System.Int64 RecordNumber = default(System.Int64), bool ArrayIsDynamic = default(bool), bool StringIsFixedLength = default(bool)) => throw null;
            public static void FilePut(int FileNumber, System.DateTime Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, System.ValueType Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, bool Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, System.Byte Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, System.Char Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, System.Decimal Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, double Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, float Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, int Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, System.Int64 Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, System.Int16 Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FilePut(int FileNumber, string Value, System.Int64 RecordNumber = default(System.Int64), bool StringIsFixedLength = default(bool)) => throw null;
            public static void FilePut(object FileNumber, object Value, object RecordNumber) => throw null;
            public static void FilePutObject(int FileNumber, object Value, System.Int64 RecordNumber = default(System.Int64)) => throw null;
            public static void FileWidth(int FileNumber, int RecordWidth) => throw null;
            public static int FreeFile() => throw null;
            public static Microsoft.VisualBasic.FileAttribute GetAttr(string PathName) => throw null;
            public static void Input(int FileNumber, ref System.DateTime Value) => throw null;
            public static void Input(int FileNumber, ref bool Value) => throw null;
            public static void Input(int FileNumber, ref System.Byte Value) => throw null;
            public static void Input(int FileNumber, ref System.Char Value) => throw null;
            public static void Input(int FileNumber, ref System.Decimal Value) => throw null;
            public static void Input(int FileNumber, ref double Value) => throw null;
            public static void Input(int FileNumber, ref float Value) => throw null;
            public static void Input(int FileNumber, ref int Value) => throw null;
            public static void Input(int FileNumber, ref System.Int64 Value) => throw null;
            public static void Input(int FileNumber, ref object Value) => throw null;
            public static void Input(int FileNumber, ref System.Int16 Value) => throw null;
            public static void Input(int FileNumber, ref string Value) => throw null;
            public static string InputString(int FileNumber, int CharCount) => throw null;
            public static void Kill(string PathName) => throw null;
            public static System.Int64 LOF(int FileNumber) => throw null;
            public static string LineInput(int FileNumber) => throw null;
            public static System.Int64 Loc(int FileNumber) => throw null;
            public static void Lock(int FileNumber) => throw null;
            public static void Lock(int FileNumber, System.Int64 Record) => throw null;
            public static void Lock(int FileNumber, System.Int64 FromRecord, System.Int64 ToRecord) => throw null;
            public static void MkDir(string Path) => throw null;
            public static void Print(int FileNumber, params object[] Output) => throw null;
            public static void PrintLine(int FileNumber, params object[] Output) => throw null;
            public static void Rename(string OldPath, string NewPath) => throw null;
            public static void Reset() => throw null;
            public static void RmDir(string Path) => throw null;
            public static Microsoft.VisualBasic.SpcInfo SPC(System.Int16 Count) => throw null;
            public static System.Int64 Seek(int FileNumber) => throw null;
            public static void Seek(int FileNumber, System.Int64 Position) => throw null;
            public static void SetAttr(string PathName, Microsoft.VisualBasic.FileAttribute Attributes) => throw null;
            public static Microsoft.VisualBasic.TabInfo TAB() => throw null;
            public static Microsoft.VisualBasic.TabInfo TAB(System.Int16 Column) => throw null;
            public static void Unlock(int FileNumber) => throw null;
            public static void Unlock(int FileNumber, System.Int64 Record) => throw null;
            public static void Unlock(int FileNumber, System.Int64 FromRecord, System.Int64 ToRecord) => throw null;
            public static void Write(int FileNumber, params object[] Output) => throw null;
            public static void WriteLine(int FileNumber, params object[] Output) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.Financial` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Financial
        {
            public static double DDB(double Cost, double Salvage, double Life, double Period, double Factor = default(double)) => throw null;
            public static double FV(double Rate, double NPer, double Pmt, double PV = default(double), Microsoft.VisualBasic.DueDate Due = default(Microsoft.VisualBasic.DueDate)) => throw null;
            public static double IPmt(double Rate, double Per, double NPer, double PV, double FV = default(double), Microsoft.VisualBasic.DueDate Due = default(Microsoft.VisualBasic.DueDate)) => throw null;
            public static double IRR(ref double[] ValueArray, double Guess = default(double)) => throw null;
            public static double MIRR(ref double[] ValueArray, double FinanceRate, double ReinvestRate) => throw null;
            public static double NPV(double Rate, ref double[] ValueArray) => throw null;
            public static double NPer(double Rate, double Pmt, double PV, double FV = default(double), Microsoft.VisualBasic.DueDate Due = default(Microsoft.VisualBasic.DueDate)) => throw null;
            public static double PPmt(double Rate, double Per, double NPer, double PV, double FV = default(double), Microsoft.VisualBasic.DueDate Due = default(Microsoft.VisualBasic.DueDate)) => throw null;
            public static double PV(double Rate, double NPer, double Pmt, double FV = default(double), Microsoft.VisualBasic.DueDate Due = default(Microsoft.VisualBasic.DueDate)) => throw null;
            public static double Pmt(double Rate, double NPer, double PV, double FV = default(double), Microsoft.VisualBasic.DueDate Due = default(Microsoft.VisualBasic.DueDate)) => throw null;
            public static double Rate(double NPer, double Pmt, double PV, double FV = default(double), Microsoft.VisualBasic.DueDate Due = default(Microsoft.VisualBasic.DueDate), double Guess = default(double)) => throw null;
            public static double SLN(double Cost, double Salvage, double Life) => throw null;
            public static double SYD(double Cost, double Salvage, double Life, double Period) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.FirstDayOfWeek` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum FirstDayOfWeek
        {
            Friday,
            Monday,
            Saturday,
            Sunday,
            System,
            Thursday,
            Tuesday,
            Wednesday,
        }

        // Generated from `Microsoft.VisualBasic.FirstWeekOfYear` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum FirstWeekOfYear
        {
            FirstFourDays,
            FirstFullWeek,
            Jan1,
            System,
        }

        // Generated from `Microsoft.VisualBasic.HideModuleNameAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class HideModuleNameAttribute : System.Attribute
        {
            public HideModuleNameAttribute() => throw null;
        }

        // Generated from `Microsoft.VisualBasic.Information` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Information
        {
            public static int Erl() => throw null;
            public static Microsoft.VisualBasic.ErrObject Err() => throw null;
            public static bool IsArray(object VarName) => throw null;
            public static bool IsDBNull(object Expression) => throw null;
            public static bool IsDate(object Expression) => throw null;
            public static bool IsError(object Expression) => throw null;
            public static bool IsNothing(object Expression) => throw null;
            public static bool IsNumeric(object Expression) => throw null;
            public static bool IsReference(object Expression) => throw null;
            public static int LBound(System.Array Array, int Rank = default(int)) => throw null;
            public static int QBColor(int Color) => throw null;
            public static int RGB(int Red, int Green, int Blue) => throw null;
            public static string SystemTypeName(string VbName) => throw null;
            public static string TypeName(object VarName) => throw null;
            public static int UBound(System.Array Array, int Rank = default(int)) => throw null;
            public static Microsoft.VisualBasic.VariantType VarType(object VarName) => throw null;
            public static string VbTypeName(string UrtName) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.Interaction` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Interaction
        {
            public static void AppActivate(int ProcessId) => throw null;
            public static void AppActivate(string Title) => throw null;
            public static void Beep() => throw null;
            public static object CallByName(object ObjectRef, string ProcName, Microsoft.VisualBasic.CallType UseCallType, params object[] Args) => throw null;
            public static object Choose(double Index, params object[] Choice) => throw null;
            public static string Command() => throw null;
            public static object CreateObject(string ProgId, string ServerName = default(string)) => throw null;
            public static void DeleteSetting(string AppName, string Section = default(string), string Key = default(string)) => throw null;
            public static string Environ(int Expression) => throw null;
            public static string Environ(string Expression) => throw null;
            public static string[] GetAllSettings(string AppName, string Section) => throw null;
            public static object GetObject(string PathName = default(string), string Class = default(string)) => throw null;
            public static string GetSetting(string AppName, string Section, string Key, string Default = default(string)) => throw null;
            public static object IIf(bool Expression, object TruePart, object FalsePart) => throw null;
            public static string InputBox(string Prompt, string Title = default(string), string DefaultResponse = default(string), int XPos = default(int), int YPos = default(int)) => throw null;
            public static Microsoft.VisualBasic.MsgBoxResult MsgBox(object Prompt, Microsoft.VisualBasic.MsgBoxStyle Buttons = default(Microsoft.VisualBasic.MsgBoxStyle), object Title = default(object)) => throw null;
            public static string Partition(System.Int64 Number, System.Int64 Start, System.Int64 Stop, System.Int64 Interval) => throw null;
            public static void SaveSetting(string AppName, string Section, string Key, string Setting) => throw null;
            public static int Shell(string PathName, Microsoft.VisualBasic.AppWinStyle Style = default(Microsoft.VisualBasic.AppWinStyle), bool Wait = default(bool), int Timeout = default(int)) => throw null;
            public static object Switch(params object[] VarExpr) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.MsgBoxResult` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum MsgBoxResult
        {
            Abort,
            Cancel,
            Ignore,
            No,
            Ok,
            Retry,
            Yes,
        }

        // Generated from `Microsoft.VisualBasic.MsgBoxStyle` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum MsgBoxStyle
        {
            AbortRetryIgnore,
            ApplicationModal,
            Critical,
            DefaultButton1,
            DefaultButton2,
            DefaultButton3,
            Exclamation,
            Information,
            MsgBoxHelp,
            MsgBoxRight,
            MsgBoxRtlReading,
            MsgBoxSetForeground,
            OkCancel,
            OkOnly,
            Question,
            RetryCancel,
            SystemModal,
            YesNo,
            YesNoCancel,
        }

        // Generated from `Microsoft.VisualBasic.MyGroupCollectionAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class MyGroupCollectionAttribute : System.Attribute
        {
            public string CreateMethod { get => throw null; }
            public string DefaultInstanceAlias { get => throw null; }
            public string DisposeMethod { get => throw null; }
            public MyGroupCollectionAttribute(string typeToCollect, string createInstanceMethodName, string disposeInstanceMethodName, string defaultInstanceAlias) => throw null;
            public string MyGroupName { get => throw null; }
        }

        // Generated from `Microsoft.VisualBasic.OpenAccess` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum OpenAccess
        {
            Default,
            Read,
            ReadWrite,
            Write,
        }

        // Generated from `Microsoft.VisualBasic.OpenMode` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum OpenMode
        {
            Append,
            Binary,
            Input,
            Output,
            Random,
        }

        // Generated from `Microsoft.VisualBasic.OpenShare` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum OpenShare
        {
            Default,
            LockRead,
            LockReadWrite,
            LockWrite,
            Shared,
        }

        // Generated from `Microsoft.VisualBasic.SpcInfo` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct SpcInfo
        {
            public System.Int16 Count;
            // Stub generator skipped constructor 
        }

        // Generated from `Microsoft.VisualBasic.Strings` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class Strings
        {
            public static int Asc(System.Char String) => throw null;
            public static int Asc(string String) => throw null;
            public static int AscW(System.Char String) => throw null;
            public static int AscW(string String) => throw null;
            public static System.Char Chr(int CharCode) => throw null;
            public static System.Char ChrW(int CharCode) => throw null;
            public static string[] Filter(object[] Source, string Match, bool Include = default(bool), Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static string[] Filter(string[] Source, string Match, bool Include = default(bool), Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static string Format(object Expression, string Style = default(string)) => throw null;
            public static string FormatCurrency(object Expression, int NumDigitsAfterDecimal = default(int), Microsoft.VisualBasic.TriState IncludeLeadingDigit = default(Microsoft.VisualBasic.TriState), Microsoft.VisualBasic.TriState UseParensForNegativeNumbers = default(Microsoft.VisualBasic.TriState), Microsoft.VisualBasic.TriState GroupDigits = default(Microsoft.VisualBasic.TriState)) => throw null;
            public static string FormatDateTime(System.DateTime Expression, Microsoft.VisualBasic.DateFormat NamedFormat = default(Microsoft.VisualBasic.DateFormat)) => throw null;
            public static string FormatNumber(object Expression, int NumDigitsAfterDecimal = default(int), Microsoft.VisualBasic.TriState IncludeLeadingDigit = default(Microsoft.VisualBasic.TriState), Microsoft.VisualBasic.TriState UseParensForNegativeNumbers = default(Microsoft.VisualBasic.TriState), Microsoft.VisualBasic.TriState GroupDigits = default(Microsoft.VisualBasic.TriState)) => throw null;
            public static string FormatPercent(object Expression, int NumDigitsAfterDecimal = default(int), Microsoft.VisualBasic.TriState IncludeLeadingDigit = default(Microsoft.VisualBasic.TriState), Microsoft.VisualBasic.TriState UseParensForNegativeNumbers = default(Microsoft.VisualBasic.TriState), Microsoft.VisualBasic.TriState GroupDigits = default(Microsoft.VisualBasic.TriState)) => throw null;
            public static System.Char GetChar(string str, int Index) => throw null;
            public static int InStr(int StartPos, string String1, string String2, Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static int InStr(string String1, string String2, Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static int InStrRev(string StringCheck, string StringMatch, int Start = default(int), Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static string Join(object[] SourceArray, string Delimiter = default(string)) => throw null;
            public static string Join(string[] SourceArray, string Delimiter = default(string)) => throw null;
            public static System.Char LCase(System.Char Value) => throw null;
            public static string LCase(string Value) => throw null;
            public static string LSet(string Source, int Length) => throw null;
            public static string LTrim(string str) => throw null;
            public static string Left(string str, int Length) => throw null;
            public static int Len(System.DateTime Expression) => throw null;
            public static int Len(bool Expression) => throw null;
            public static int Len(System.Byte Expression) => throw null;
            public static int Len(System.Char Expression) => throw null;
            public static int Len(System.Decimal Expression) => throw null;
            public static int Len(double Expression) => throw null;
            public static int Len(float Expression) => throw null;
            public static int Len(int Expression) => throw null;
            public static int Len(System.Int64 Expression) => throw null;
            public static int Len(object Expression) => throw null;
            public static int Len(System.SByte Expression) => throw null;
            public static int Len(System.Int16 Expression) => throw null;
            public static int Len(string Expression) => throw null;
            public static int Len(System.UInt32 Expression) => throw null;
            public static int Len(System.UInt64 Expression) => throw null;
            public static int Len(System.UInt16 Expression) => throw null;
            public static string Mid(string str, int Start) => throw null;
            public static string Mid(string str, int Start, int Length) => throw null;
            public static string RSet(string Source, int Length) => throw null;
            public static string RTrim(string str) => throw null;
            public static string Replace(string Expression, string Find, string Replacement, int Start = default(int), int Count = default(int), Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static string Right(string str, int Length) => throw null;
            public static string Space(int Number) => throw null;
            public static string[] Split(string Expression, string Delimiter = default(string), int Limit = default(int), Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static int StrComp(string String1, string String2, Microsoft.VisualBasic.CompareMethod Compare = default(Microsoft.VisualBasic.CompareMethod)) => throw null;
            public static string StrConv(string str, Microsoft.VisualBasic.VbStrConv Conversion, int LocaleID = default(int)) => throw null;
            public static string StrDup(int Number, System.Char Character) => throw null;
            public static object StrDup(int Number, object Character) => throw null;
            public static string StrDup(int Number, string Character) => throw null;
            public static string StrReverse(string Expression) => throw null;
            public static string Trim(string str) => throw null;
            public static System.Char UCase(System.Char Value) => throw null;
            public static string UCase(string Value) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.TabInfo` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public struct TabInfo
        {
            public System.Int16 Column;
            // Stub generator skipped constructor 
        }

        // Generated from `Microsoft.VisualBasic.TriState` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum TriState
        {
            False,
            True,
            UseDefault,
        }

        // Generated from `Microsoft.VisualBasic.VBFixedArrayAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class VBFixedArrayAttribute : System.Attribute
        {
            public int[] Bounds { get => throw null; }
            public int Length { get => throw null; }
            public VBFixedArrayAttribute(int UpperBound1) => throw null;
            public VBFixedArrayAttribute(int UpperBound1, int UpperBound2) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.VBFixedStringAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class VBFixedStringAttribute : System.Attribute
        {
            public int Length { get => throw null; }
            public VBFixedStringAttribute(int Length) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.VBMath` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class VBMath
        {
            public static void Randomize() => throw null;
            public static void Randomize(double Number) => throw null;
            public static float Rnd() => throw null;
            public static float Rnd(float Number) => throw null;
        }

        // Generated from `Microsoft.VisualBasic.VariantType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum VariantType
        {
            Array,
            Boolean,
            Byte,
            Char,
            Currency,
            DataObject,
            Date,
            Decimal,
            Double,
            Empty,
            Error,
            Integer,
            Long,
            Null,
            Object,
            Short,
            Single,
            String,
            UserDefinedType,
            Variant,
        }

        // Generated from `Microsoft.VisualBasic.VbStrConv` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum VbStrConv
        {
            Hiragana,
            Katakana,
            LinguisticCasing,
            Lowercase,
            Narrow,
            None,
            ProperCase,
            SimplifiedChinese,
            TraditionalChinese,
            Uppercase,
            Wide,
        }

        namespace CompilerServices
        {
            // Generated from `Microsoft.VisualBasic.CompilerServices.BooleanType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class BooleanType
            {
                public static bool FromObject(object Value) => throw null;
                public static bool FromString(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.ByteType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ByteType
            {
                public static System.Byte FromObject(object Value) => throw null;
                public static System.Byte FromString(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.CharArrayType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CharArrayType
            {
                public static System.Char[] FromObject(object Value) => throw null;
                public static System.Char[] FromString(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.CharType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CharType
            {
                public static System.Char FromObject(object Value) => throw null;
                public static System.Char FromString(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.Conversions` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Conversions
            {
                public static object ChangeType(object Expression, System.Type TargetType) => throw null;
                public static object FallbackUserDefinedConversion(object Expression, System.Type TargetType) => throw null;
                public static string FromCharAndCount(System.Char Value, int Count) => throw null;
                public static string FromCharArray(System.Char[] Value) => throw null;
                public static string FromCharArraySubset(System.Char[] Value, int StartIndex, int Length) => throw null;
                public static bool ToBoolean(object Value) => throw null;
                public static bool ToBoolean(string Value) => throw null;
                public static System.Byte ToByte(object Value) => throw null;
                public static System.Byte ToByte(string Value) => throw null;
                public static System.Char ToChar(object Value) => throw null;
                public static System.Char ToChar(string Value) => throw null;
                public static System.Char[] ToCharArrayRankOne(object Value) => throw null;
                public static System.Char[] ToCharArrayRankOne(string Value) => throw null;
                public static System.DateTime ToDate(object Value) => throw null;
                public static System.DateTime ToDate(string Value) => throw null;
                public static System.Decimal ToDecimal(bool Value) => throw null;
                public static System.Decimal ToDecimal(object Value) => throw null;
                public static System.Decimal ToDecimal(string Value) => throw null;
                public static double ToDouble(object Value) => throw null;
                public static double ToDouble(string Value) => throw null;
                public static T ToGenericParameter<T>(object Value) => throw null;
                public static int ToInteger(object Value) => throw null;
                public static int ToInteger(string Value) => throw null;
                public static System.Int64 ToLong(object Value) => throw null;
                public static System.Int64 ToLong(string Value) => throw null;
                public static System.SByte ToSByte(object Value) => throw null;
                public static System.SByte ToSByte(string Value) => throw null;
                public static System.Int16 ToShort(object Value) => throw null;
                public static System.Int16 ToShort(string Value) => throw null;
                public static float ToSingle(object Value) => throw null;
                public static float ToSingle(string Value) => throw null;
                public static string ToString(System.DateTime Value) => throw null;
                public static string ToString(bool Value) => throw null;
                public static string ToString(System.Byte Value) => throw null;
                public static string ToString(System.Char Value) => throw null;
                public static string ToString(System.Decimal Value) => throw null;
                public static string ToString(System.Decimal Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static string ToString(double Value) => throw null;
                public static string ToString(double Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static string ToString(float Value) => throw null;
                public static string ToString(float Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static string ToString(int Value) => throw null;
                public static string ToString(System.Int64 Value) => throw null;
                public static string ToString(object Value) => throw null;
                public static string ToString(System.Int16 Value) => throw null;
                public static string ToString(System.UInt32 Value) => throw null;
                public static string ToString(System.UInt64 Value) => throw null;
                public static System.UInt32 ToUInteger(object Value) => throw null;
                public static System.UInt32 ToUInteger(string Value) => throw null;
                public static System.UInt64 ToULong(object Value) => throw null;
                public static System.UInt64 ToULong(string Value) => throw null;
                public static System.UInt16 ToUShort(object Value) => throw null;
                public static System.UInt16 ToUShort(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.DateType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DateType
            {
                public static System.DateTime FromObject(object Value) => throw null;
                public static System.DateTime FromString(string Value) => throw null;
                public static System.DateTime FromString(string Value, System.Globalization.CultureInfo culture) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.DecimalType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DecimalType
            {
                public static System.Decimal FromBoolean(bool Value) => throw null;
                public static System.Decimal FromObject(object Value) => throw null;
                public static System.Decimal FromObject(object Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static System.Decimal FromString(string Value) => throw null;
                public static System.Decimal FromString(string Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static System.Decimal Parse(string Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.DesignerGeneratedAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DesignerGeneratedAttribute : System.Attribute
            {
                public DesignerGeneratedAttribute() => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.DoubleType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DoubleType
            {
                public static double FromObject(object Value) => throw null;
                public static double FromObject(object Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static double FromString(string Value) => throw null;
                public static double FromString(string Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static double Parse(string Value) => throw null;
                public static double Parse(string Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.IncompleteInitialization` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IncompleteInitialization : System.Exception
            {
                public IncompleteInitialization() => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.IntegerType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IntegerType
            {
                public static int FromObject(object Value) => throw null;
                public static int FromString(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.LateBinding` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class LateBinding
            {
                public static void LateCall(object o, System.Type objType, string name, object[] args, string[] paramnames, bool[] CopyBack) => throw null;
                public static object LateGet(object o, System.Type objType, string name, object[] args, string[] paramnames, bool[] CopyBack) => throw null;
                public static object LateIndexGet(object o, object[] args, string[] paramnames) => throw null;
                public static void LateIndexSet(object o, object[] args, string[] paramnames) => throw null;
                public static void LateIndexSetComplex(object o, object[] args, string[] paramnames, bool OptimisticSet, bool RValueBase) => throw null;
                public static void LateSet(object o, System.Type objType, string name, object[] args, string[] paramnames) => throw null;
                public static void LateSetComplex(object o, System.Type objType, string name, object[] args, string[] paramnames, bool OptimisticSet, bool RValueBase) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.LikeOperator` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class LikeOperator
            {
                public static object LikeObject(object Source, object Pattern, Microsoft.VisualBasic.CompareMethod CompareOption) => throw null;
                public static bool LikeString(string Source, string Pattern, Microsoft.VisualBasic.CompareMethod CompareOption) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.LongType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class LongType
            {
                public static System.Int64 FromObject(object Value) => throw null;
                public static System.Int64 FromString(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.NewLateBinding` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NewLateBinding
            {
                public static object FallbackCall(object Instance, string MemberName, object[] Arguments, string[] ArgumentNames, bool IgnoreReturn) => throw null;
                public static object FallbackGet(object Instance, string MemberName, object[] Arguments, string[] ArgumentNames) => throw null;
                public static void FallbackIndexSet(object Instance, object[] Arguments, string[] ArgumentNames) => throw null;
                public static void FallbackIndexSetComplex(object Instance, object[] Arguments, string[] ArgumentNames, bool OptimisticSet, bool RValueBase) => throw null;
                public static object FallbackInvokeDefault1(object Instance, object[] Arguments, string[] ArgumentNames, bool ReportErrors) => throw null;
                public static object FallbackInvokeDefault2(object Instance, object[] Arguments, string[] ArgumentNames, bool ReportErrors) => throw null;
                public static void FallbackSet(object Instance, string MemberName, object[] Arguments) => throw null;
                public static void FallbackSetComplex(object Instance, string MemberName, object[] Arguments, bool OptimisticSet, bool RValueBase) => throw null;
                public static object LateCall(object Instance, System.Type Type, string MemberName, object[] Arguments, string[] ArgumentNames, System.Type[] TypeArguments, bool[] CopyBack, bool IgnoreReturn) => throw null;
                public static object LateCallInvokeDefault(object Instance, object[] Arguments, string[] ArgumentNames, bool ReportErrors) => throw null;
                public static object LateGet(object Instance, System.Type Type, string MemberName, object[] Arguments, string[] ArgumentNames, System.Type[] TypeArguments, bool[] CopyBack) => throw null;
                public static object LateGetInvokeDefault(object Instance, object[] Arguments, string[] ArgumentNames, bool ReportErrors) => throw null;
                public static object LateIndexGet(object Instance, object[] Arguments, string[] ArgumentNames) => throw null;
                public static void LateIndexSet(object Instance, object[] Arguments, string[] ArgumentNames) => throw null;
                public static void LateIndexSetComplex(object Instance, object[] Arguments, string[] ArgumentNames, bool OptimisticSet, bool RValueBase) => throw null;
                public static void LateSet(object Instance, System.Type Type, string MemberName, object[] Arguments, string[] ArgumentNames, System.Type[] TypeArguments) => throw null;
                public static void LateSet(object Instance, System.Type Type, string MemberName, object[] Arguments, string[] ArgumentNames, System.Type[] TypeArguments, bool OptimisticSet, bool RValueBase, Microsoft.VisualBasic.CallType CallType) => throw null;
                public static void LateSetComplex(object Instance, System.Type Type, string MemberName, object[] Arguments, string[] ArgumentNames, System.Type[] TypeArguments, bool OptimisticSet, bool RValueBase) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.ObjectFlowControl` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ObjectFlowControl
            {
                // Generated from `Microsoft.VisualBasic.CompilerServices.ObjectFlowControl+ForLoopControl` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public class ForLoopControl
                {
                    public static bool ForLoopInitObj(object Counter, object Start, object Limit, object StepValue, ref object LoopForResult, ref object CounterResult) => throw null;
                    public static bool ForNextCheckDec(System.Decimal count, System.Decimal limit, System.Decimal StepValue) => throw null;
                    public static bool ForNextCheckObj(object Counter, object LoopObj, ref object CounterResult) => throw null;
                    public static bool ForNextCheckR4(float count, float limit, float StepValue) => throw null;
                    public static bool ForNextCheckR8(double count, double limit, double StepValue) => throw null;
                }


                public static void CheckForSyncLockOnValueType(object Expression) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.ObjectType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ObjectType
            {
                public static object AddObj(object o1, object o2) => throw null;
                public static object BitAndObj(object obj1, object obj2) => throw null;
                public static object BitOrObj(object obj1, object obj2) => throw null;
                public static object BitXorObj(object obj1, object obj2) => throw null;
                public static object DivObj(object o1, object o2) => throw null;
                public static object GetObjectValuePrimitive(object o) => throw null;
                public static object IDivObj(object o1, object o2) => throw null;
                public static bool LikeObj(object vLeft, object vRight, Microsoft.VisualBasic.CompareMethod CompareOption) => throw null;
                public static object ModObj(object o1, object o2) => throw null;
                public static object MulObj(object o1, object o2) => throw null;
                public static object NegObj(object obj) => throw null;
                public static object NotObj(object obj) => throw null;
                public static int ObjTst(object o1, object o2, bool TextCompare) => throw null;
                public ObjectType() => throw null;
                public static object PlusObj(object obj) => throw null;
                public static object PowObj(object obj1, object obj2) => throw null;
                public static object ShiftLeftObj(object o1, int amount) => throw null;
                public static object ShiftRightObj(object o1, int amount) => throw null;
                public static object StrCatObj(object vLeft, object vRight) => throw null;
                public static object SubObj(object o1, object o2) => throw null;
                public static object XorObj(object obj1, object obj2) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.Operators` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Operators
            {
                public static object AddObject(object Left, object Right) => throw null;
                public static object AndObject(object Left, object Right) => throw null;
                public static object CompareObjectEqual(object Left, object Right, bool TextCompare) => throw null;
                public static object CompareObjectGreater(object Left, object Right, bool TextCompare) => throw null;
                public static object CompareObjectGreaterEqual(object Left, object Right, bool TextCompare) => throw null;
                public static object CompareObjectLess(object Left, object Right, bool TextCompare) => throw null;
                public static object CompareObjectLessEqual(object Left, object Right, bool TextCompare) => throw null;
                public static object CompareObjectNotEqual(object Left, object Right, bool TextCompare) => throw null;
                public static int CompareString(string Left, string Right, bool TextCompare) => throw null;
                public static object ConcatenateObject(object Left, object Right) => throw null;
                public static bool ConditionalCompareObjectEqual(object Left, object Right, bool TextCompare) => throw null;
                public static bool ConditionalCompareObjectGreater(object Left, object Right, bool TextCompare) => throw null;
                public static bool ConditionalCompareObjectGreaterEqual(object Left, object Right, bool TextCompare) => throw null;
                public static bool ConditionalCompareObjectLess(object Left, object Right, bool TextCompare) => throw null;
                public static bool ConditionalCompareObjectLessEqual(object Left, object Right, bool TextCompare) => throw null;
                public static bool ConditionalCompareObjectNotEqual(object Left, object Right, bool TextCompare) => throw null;
                public static object DivideObject(object Left, object Right) => throw null;
                public static object ExponentObject(object Left, object Right) => throw null;
                public static object FallbackInvokeUserDefinedOperator(object vbOp, object[] arguments) => throw null;
                public static object IntDivideObject(object Left, object Right) => throw null;
                public static object LeftShiftObject(object Operand, object Amount) => throw null;
                public static object ModObject(object Left, object Right) => throw null;
                public static object MultiplyObject(object Left, object Right) => throw null;
                public static object NegateObject(object Operand) => throw null;
                public static object NotObject(object Operand) => throw null;
                public static object OrObject(object Left, object Right) => throw null;
                public static object PlusObject(object Operand) => throw null;
                public static object RightShiftObject(object Operand, object Amount) => throw null;
                public static object SubtractObject(object Left, object Right) => throw null;
                public static object XorObject(object Left, object Right) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.OptionCompareAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OptionCompareAttribute : System.Attribute
            {
                public OptionCompareAttribute() => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.OptionTextAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OptionTextAttribute : System.Attribute
            {
                public OptionTextAttribute() => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.ProjectData` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ProjectData
            {
                public static void ClearProjectError() => throw null;
                public static System.Exception CreateProjectError(int hr) => throw null;
                public static void EndApp() => throw null;
                public static void SetProjectError(System.Exception ex) => throw null;
                public static void SetProjectError(System.Exception ex, int lErl) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.ShortType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ShortType
            {
                public static System.Int16 FromObject(object Value) => throw null;
                public static System.Int16 FromString(string Value) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.SingleType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SingleType
            {
                public static float FromObject(object Value) => throw null;
                public static float FromObject(object Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static float FromString(string Value) => throw null;
                public static float FromString(string Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.StandardModuleAttribute` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StandardModuleAttribute : System.Attribute
            {
                public StandardModuleAttribute() => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.StaticLocalInitFlag` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StaticLocalInitFlag
            {
                public System.Int16 State;
                public StaticLocalInitFlag() => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.StringType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class StringType
            {
                public static string FromBoolean(bool Value) => throw null;
                public static string FromByte(System.Byte Value) => throw null;
                public static string FromChar(System.Char Value) => throw null;
                public static string FromDate(System.DateTime Value) => throw null;
                public static string FromDecimal(System.Decimal Value) => throw null;
                public static string FromDecimal(System.Decimal Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static string FromDouble(double Value) => throw null;
                public static string FromDouble(double Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static string FromInteger(int Value) => throw null;
                public static string FromLong(System.Int64 Value) => throw null;
                public static string FromObject(object Value) => throw null;
                public static string FromShort(System.Int16 Value) => throw null;
                public static string FromSingle(float Value) => throw null;
                public static string FromSingle(float Value, System.Globalization.NumberFormatInfo NumberFormat) => throw null;
                public static void MidStmtStr(ref string sDest, int StartPosition, int MaxInsertLength, string sInsert) => throw null;
                public static int StrCmp(string sLeft, string sRight, bool TextCompare) => throw null;
                public static bool StrLike(string Source, string Pattern, Microsoft.VisualBasic.CompareMethod CompareOption) => throw null;
                public static bool StrLikeBinary(string Source, string Pattern) => throw null;
                public static bool StrLikeText(string Source, string Pattern) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.Utils` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Utils
            {
                public static System.Array CopyArray(System.Array arySrc, System.Array aryDest) => throw null;
                public static string GetResourceString(string ResourceKey, params string[] Args) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.CompilerServices.Versioned` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Versioned
            {
                public static object CallByName(object Instance, string MethodName, Microsoft.VisualBasic.CallType UseCallType, params object[] Arguments) => throw null;
                public static bool IsNumeric(object Expression) => throw null;
                public static string SystemTypeName(string VbName) => throw null;
                public static string TypeName(object Expression) => throw null;
                public static string VbTypeName(string SystemName) => throw null;
            }

        }
        namespace FileIO
        {
            // Generated from `Microsoft.VisualBasic.FileIO.DeleteDirectoryOption` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum DeleteDirectoryOption
            {
                DeleteAllContents,
                ThrowIfDirectoryNonEmpty,
            }

            // Generated from `Microsoft.VisualBasic.FileIO.FieldType` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum FieldType
            {
                Delimited,
                FixedWidth,
            }

            // Generated from `Microsoft.VisualBasic.FileIO.FileSystem` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FileSystem
            {
                public static string CombinePath(string baseDirectory, string relativePath) => throw null;
                public static void CopyDirectory(string sourceDirectoryName, string destinationDirectoryName) => throw null;
                public static void CopyDirectory(string sourceDirectoryName, string destinationDirectoryName, Microsoft.VisualBasic.FileIO.UIOption showUI) => throw null;
                public static void CopyDirectory(string sourceDirectoryName, string destinationDirectoryName, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.UICancelOption onUserCancel) => throw null;
                public static void CopyDirectory(string sourceDirectoryName, string destinationDirectoryName, bool overwrite) => throw null;
                public static void CopyFile(string sourceFileName, string destinationFileName) => throw null;
                public static void CopyFile(string sourceFileName, string destinationFileName, Microsoft.VisualBasic.FileIO.UIOption showUI) => throw null;
                public static void CopyFile(string sourceFileName, string destinationFileName, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.UICancelOption onUserCancel) => throw null;
                public static void CopyFile(string sourceFileName, string destinationFileName, bool overwrite) => throw null;
                public static void CreateDirectory(string directory) => throw null;
                public static string CurrentDirectory { get => throw null; set => throw null; }
                public static void DeleteDirectory(string directory, Microsoft.VisualBasic.FileIO.DeleteDirectoryOption onDirectoryNotEmpty) => throw null;
                public static void DeleteDirectory(string directory, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.RecycleOption recycle) => throw null;
                public static void DeleteDirectory(string directory, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.RecycleOption recycle, Microsoft.VisualBasic.FileIO.UICancelOption onUserCancel) => throw null;
                public static void DeleteFile(string file) => throw null;
                public static void DeleteFile(string file, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.RecycleOption recycle) => throw null;
                public static void DeleteFile(string file, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.RecycleOption recycle, Microsoft.VisualBasic.FileIO.UICancelOption onUserCancel) => throw null;
                public static bool DirectoryExists(string directory) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<System.IO.DriveInfo> Drives { get => throw null; }
                public static bool FileExists(string file) => throw null;
                public FileSystem() => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<string> FindInFiles(string directory, string containsText, bool ignoreCase, Microsoft.VisualBasic.FileIO.SearchOption searchType) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<string> FindInFiles(string directory, string containsText, bool ignoreCase, Microsoft.VisualBasic.FileIO.SearchOption searchType, params string[] fileWildcards) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<string> GetDirectories(string directory) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<string> GetDirectories(string directory, Microsoft.VisualBasic.FileIO.SearchOption searchType, params string[] wildcards) => throw null;
                public static System.IO.DirectoryInfo GetDirectoryInfo(string directory) => throw null;
                public static System.IO.DriveInfo GetDriveInfo(string drive) => throw null;
                public static System.IO.FileInfo GetFileInfo(string file) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<string> GetFiles(string directory) => throw null;
                public static System.Collections.ObjectModel.ReadOnlyCollection<string> GetFiles(string directory, Microsoft.VisualBasic.FileIO.SearchOption searchType, params string[] wildcards) => throw null;
                public static string GetName(string path) => throw null;
                public static string GetParentPath(string path) => throw null;
                public static string GetTempFileName() => throw null;
                public static void MoveDirectory(string sourceDirectoryName, string destinationDirectoryName) => throw null;
                public static void MoveDirectory(string sourceDirectoryName, string destinationDirectoryName, Microsoft.VisualBasic.FileIO.UIOption showUI) => throw null;
                public static void MoveDirectory(string sourceDirectoryName, string destinationDirectoryName, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.UICancelOption onUserCancel) => throw null;
                public static void MoveDirectory(string sourceDirectoryName, string destinationDirectoryName, bool overwrite) => throw null;
                public static void MoveFile(string sourceFileName, string destinationFileName) => throw null;
                public static void MoveFile(string sourceFileName, string destinationFileName, Microsoft.VisualBasic.FileIO.UIOption showUI) => throw null;
                public static void MoveFile(string sourceFileName, string destinationFileName, Microsoft.VisualBasic.FileIO.UIOption showUI, Microsoft.VisualBasic.FileIO.UICancelOption onUserCancel) => throw null;
                public static void MoveFile(string sourceFileName, string destinationFileName, bool overwrite) => throw null;
                public static Microsoft.VisualBasic.FileIO.TextFieldParser OpenTextFieldParser(string file) => throw null;
                public static Microsoft.VisualBasic.FileIO.TextFieldParser OpenTextFieldParser(string file, params int[] fieldWidths) => throw null;
                public static Microsoft.VisualBasic.FileIO.TextFieldParser OpenTextFieldParser(string file, params string[] delimiters) => throw null;
                public static System.IO.StreamReader OpenTextFileReader(string file) => throw null;
                public static System.IO.StreamReader OpenTextFileReader(string file, System.Text.Encoding encoding) => throw null;
                public static System.IO.StreamWriter OpenTextFileWriter(string file, bool append) => throw null;
                public static System.IO.StreamWriter OpenTextFileWriter(string file, bool append, System.Text.Encoding encoding) => throw null;
                public static System.Byte[] ReadAllBytes(string file) => throw null;
                public static string ReadAllText(string file) => throw null;
                public static string ReadAllText(string file, System.Text.Encoding encoding) => throw null;
                public static void RenameDirectory(string directory, string newName) => throw null;
                public static void RenameFile(string file, string newName) => throw null;
                public static void WriteAllBytes(string file, System.Byte[] data, bool append) => throw null;
                public static void WriteAllText(string file, string text, bool append) => throw null;
                public static void WriteAllText(string file, string text, bool append, System.Text.Encoding encoding) => throw null;
            }

            // Generated from `Microsoft.VisualBasic.FileIO.MalformedLineException` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MalformedLineException : System.Exception
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Int64 LineNumber { get => throw null; set => throw null; }
                public MalformedLineException() => throw null;
                protected MalformedLineException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public MalformedLineException(string message) => throw null;
                public MalformedLineException(string message, System.Exception innerException) => throw null;
                public MalformedLineException(string message, System.Int64 lineNumber) => throw null;
                public MalformedLineException(string message, System.Int64 lineNumber, System.Exception innerException) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `Microsoft.VisualBasic.FileIO.RecycleOption` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum RecycleOption
            {
                DeletePermanently,
                SendToRecycleBin,
            }

            // Generated from `Microsoft.VisualBasic.FileIO.SearchOption` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SearchOption
            {
                SearchAllSubDirectories,
                SearchTopLevelOnly,
            }

            // Generated from `Microsoft.VisualBasic.FileIO.SpecialDirectories` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SpecialDirectories
            {
                public static string AllUsersApplicationData { get => throw null; }
                public static string CurrentUserApplicationData { get => throw null; }
                public static string Desktop { get => throw null; }
                public static string MyDocuments { get => throw null; }
                public static string MyMusic { get => throw null; }
                public static string MyPictures { get => throw null; }
                public static string ProgramFiles { get => throw null; }
                public static string Programs { get => throw null; }
                public SpecialDirectories() => throw null;
                public static string Temp { get => throw null; }
            }

            // Generated from `Microsoft.VisualBasic.FileIO.TextFieldParser` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class TextFieldParser : System.IDisposable
            {
                public void Close() => throw null;
                public string[] CommentTokens { get => throw null; set => throw null; }
                public string[] Delimiters { get => throw null; set => throw null; }
                void System.IDisposable.Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public bool EndOfData { get => throw null; }
                public string ErrorLine { get => throw null; }
                public System.Int64 ErrorLineNumber { get => throw null; }
                public int[] FieldWidths { get => throw null; set => throw null; }
                public bool HasFieldsEnclosedInQuotes { get => throw null; set => throw null; }
                public System.Int64 LineNumber { get => throw null; }
                public string PeekChars(int numberOfChars) => throw null;
                public string[] ReadFields() => throw null;
                public string ReadLine() => throw null;
                public string ReadToEnd() => throw null;
                public void SetDelimiters(params string[] delimiters) => throw null;
                public void SetFieldWidths(params int[] fieldWidths) => throw null;
                public TextFieldParser(System.IO.Stream stream) => throw null;
                public TextFieldParser(System.IO.Stream stream, System.Text.Encoding defaultEncoding) => throw null;
                public TextFieldParser(System.IO.Stream stream, System.Text.Encoding defaultEncoding, bool detectEncoding) => throw null;
                public TextFieldParser(System.IO.Stream stream, System.Text.Encoding defaultEncoding, bool detectEncoding, bool leaveOpen) => throw null;
                public TextFieldParser(System.IO.TextReader reader) => throw null;
                public TextFieldParser(string path) => throw null;
                public TextFieldParser(string path, System.Text.Encoding defaultEncoding) => throw null;
                public TextFieldParser(string path, System.Text.Encoding defaultEncoding, bool detectEncoding) => throw null;
                public Microsoft.VisualBasic.FileIO.FieldType TextFieldType { get => throw null; set => throw null; }
                public bool TrimWhiteSpace { get => throw null; set => throw null; }
                // ERR: Stub generator didn't handle member: ~TextFieldParser
            }

            // Generated from `Microsoft.VisualBasic.FileIO.UICancelOption` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum UICancelOption
            {
                DoNothing,
                ThrowException,
            }

            // Generated from `Microsoft.VisualBasic.FileIO.UIOption` in `Microsoft.VisualBasic.Core, Version=10.0.6.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum UIOption
            {
                AllDialogs,
                OnlyErrorDialogs,
            }

        }
    }
}
