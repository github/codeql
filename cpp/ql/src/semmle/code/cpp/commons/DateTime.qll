/**
 * Provides a library for helping working with a set of known data structures representing dates in C++.
 */

import cpp

/**
 * A type that is used to represent time in a 'packed' form, such as an integer.
 */
class FileTimeStruct extends Type {
  FileTimeStruct() {
    this.toString() = "_FILETIME"
    or this.toString().matches("_FILETIME %")
  }
}

/**
 * A type that is used to represent times and dates in an 'unpacked' form, that is,
 * with separate fields for day, month, year etc.
 */
class DateDataStruct extends Type {
  DateDataStruct() {
    this.toString() = "_SYSTEMTIME"
    or this.toString() = "SYSTEMTIME"
    or this.toString() = "tm"
    or this.toString().matches("_SYSTEMTIME %")
    or this.toString().matches("SYSTEMTIME %")
    or this.toString().matches("tm %")
  }
}

/**
 * A `FieldAccess` that would represent an access to a field on a `struct`.
 */
abstract class StructFieldAccess extends FieldAccess {
    StructFieldAccess () {
      exists(Field f, StructLikeClass struct |
        f.getAnAccess() = this
        and struct.getAField() = f
      )
   }
}

/**
 * A `FieldAccess` where access is to a day of the month field of the `struct`.
 */
abstract class DayFieldAccess extends StructFieldAccess { }

/**
 * A `FieldAccess` where access is to a month field of the `struct`.
 */
abstract class MonthFieldAccess extends StructFieldAccess {}

/**
 * A `FieldAccess` where access is to a year field of the `struct`.
 */
abstract class YearFieldAccess extends StructFieldAccess {}

/**
 * A `DayFieldAccess` for the `SYSTEMTIME` struct.
 */
class SystemTimeDayFieldAccess extends DayFieldAccess {
  SystemTimeDayFieldAccess () {
    this.toString() = "wDay"
  }
}

/**
 * A `MonthFieldAccess` for the `SYSTEMTIME` struct.
 */
class SystemTimeMonthFieldAccess extends MonthFieldAccess {
  SystemTimeMonthFieldAccess () {
    this.toString() = "wMonth"
  }
}

/**
 * A `YearFieldAccess` for the `SYSTEMTIME` struct.
 */
class StructSystemTimeYearFieldAccess extends YearFieldAccess {
  StructSystemTimeYearFieldAccess() {
    this.toString() = "wYear"
  }
}

/**
 * A `DayFieldAccess` for `struct tm`.
 */
class StructTmDayFieldAccess extends DayFieldAccess {
  StructTmDayFieldAccess() {
    this.toString() = "tm_mday"
  }
}

/**
 * A `MonthFieldAccess` for `struct tm`.
 */
class StructTmMonthFieldAccess extends MonthFieldAccess {
  StructTmMonthFieldAccess() {
    this.toString() = "tm_mon"
  }
}

/**
 * A `YearFieldAccess` for `struct tm`.
 */
class StructTmYearFieldAccess extends YearFieldAccess {
  StructTmYearFieldAccess() {
    this.toString() = "tm_year"
  }
}
