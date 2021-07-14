/**
 * Provides a library for helping working with a set of known data structures representing dates in C++.
 */

import cpp

/**
 * A type that is used to represent time in a 'packed' form, such as an integer.
 */
class PackedTimeType extends Type {
  PackedTimeType() {
    this.getName() = "_FILETIME" or
    this.(DerivedType).getBaseType*().getName() = "_FILETIME"
  }
}

private predicate timeType(string typeName) { typeName = ["_SYSTEMTIME", "SYSTEMTIME", "tm"] }

/**
 * A type that is used to represent times and dates in an 'unpacked' form, that is,
 * with separate fields for day, month, year etc.
 */
class UnpackedTimeType extends Type {
  UnpackedTimeType() {
    timeType(this.getName()) or
    timeType(this.(DerivedType).getBaseType*().getName())
  }
}

/**
 * A `FieldAccess` that would represent an access to a field on a `struct`.
 */
abstract private class DateStructFieldAccess extends FieldAccess {
  DateStructFieldAccess() {
    exists(Field f, StructLikeClass struct |
      f.getAnAccess() = this and
      struct.getAField() = f
    )
  }
}

/**
 * A `FieldAccess` where access is to a day of the month field of the `struct`.
 */
abstract class DayFieldAccess extends DateStructFieldAccess { }

/**
 * A `FieldAccess` where access is to a month field of the `struct`.
 */
abstract class MonthFieldAccess extends DateStructFieldAccess { }

/**
 * A `FieldAccess` where access is to a year field of the `struct`.
 */
abstract class YearFieldAccess extends DateStructFieldAccess { }

/**
 * A `DayFieldAccess` for the `SYSTEMTIME` struct.
 */
class SystemTimeDayFieldAccess extends DayFieldAccess {
  SystemTimeDayFieldAccess() { this.getTarget().getName() = "wDay" }
}

/**
 * A `MonthFieldAccess` for the `SYSTEMTIME` struct.
 */
class SystemTimeMonthFieldAccess extends MonthFieldAccess {
  SystemTimeMonthFieldAccess() { this.getTarget().getName() = "wMonth" }
}

/**
 * A `YearFieldAccess` for the `SYSTEMTIME` struct.
 */
class StructSystemTimeYearFieldAccess extends YearFieldAccess {
  StructSystemTimeYearFieldAccess() { this.getTarget().getName() = "wYear" }
}

/**
 * A `DayFieldAccess` for `struct tm`.
 */
class StructTmDayFieldAccess extends DayFieldAccess {
  StructTmDayFieldAccess() { this.getTarget().getName() = "tm_mday" }
}

/**
 * A `MonthFieldAccess` for `struct tm`.
 */
class StructTmMonthFieldAccess extends MonthFieldAccess {
  StructTmMonthFieldAccess() { this.getTarget().getName() = "tm_mon" }
}

/**
 * A `YearFieldAccess` for `struct tm`.
 */
class StructTmYearFieldAccess extends YearFieldAccess {
  StructTmYearFieldAccess() { this.getTarget().getName() = "tm_year" }
}
