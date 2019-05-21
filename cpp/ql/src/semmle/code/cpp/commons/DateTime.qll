/**
 * Provides a library for helping working with a set of known data structures representing dates in C++
 */

import cpp

class FileTimeStruct extends Type {
  FileTimeStruct() {
    this.toString().matches("_FILETIME")
    or this.toString().matches("_FILETIME %")
  }
}

/**
 * Type of known data structures that are used for date representation.
 */
class DateDataStruct extends Type {
  DateDataStruct() {
    this.toString().matches("_SYSTEMTIME")
    or this.toString().matches("SYSTEMTIME")
    or this.toString().matches("tm")
    or this.toString().matches("_SYSTEMTIME %")
    or this.toString().matches("SYSTEMTIME %")
    or this.toString().matches("tm %")
  }
}

/**
 * abstract class of type FieldAccess that would represent an access to a field on a struct
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
 * abstract class of type FieldAccess where access is to a day of the month field of the struct
 * This is to be derived form for a specific struct's day of the month field access
 */
abstract class DayFieldAccess extends StructFieldAccess { }

/**
 * abstract class of type FieldAccess where access is to a month field of the struct
 * This is to be derived form for a specific struct's month field access
 */
abstract class MonthFieldAccess extends StructFieldAccess {}

/**
 * abstract class of type FieldAccess where access is to a year field of the struct
 * This is to be derived form for a specific struct's year field access
 */
abstract class YearFieldAccess extends StructFieldAccess {}

/**
 * DayFieldAccess for SYSTEMTIME struct
 */
class SystemTimeDayFieldAccess extends DayFieldAccess {
  SystemTimeDayFieldAccess () {
    this.toString().matches("wDay") 
  }
}

/**
 * MonthFieldAccess for SYSTEMTIME struct
 */
class SystemTimeMonthFieldAccess extends MonthFieldAccess {
  SystemTimeMonthFieldAccess () {
    this.toString().matches("wMonth") 
  }
}

/**
 * YearFieldAccess for SYSTEMTIME struct
 */
class StructSystemTimeYearFieldAccess extends YearFieldAccess {
  StructSystemTimeYearFieldAccess() {
    this.toString().matches("wYear") 
  }
}

/**
 * DayFieldAccess for struct tm
 */
class StructTmDayFieldAccess extends DayFieldAccess {
  StructTmDayFieldAccess() {
    this.toString().matches("tm_mday") 
  }
}

/**
 * MonthFieldAccess for struct tm
 */
class StructTmMonthFieldAccess extends MonthFieldAccess {
  StructTmMonthFieldAccess() {
    this.toString().matches("tm_mon") 
  }
}

/**
 * YearFieldAccess for struct tm
 */
class StructTmYearFieldAccess extends YearFieldAccess {
  StructTmYearFieldAccess() {
    this.toString().matches("tm_year") 
  }
}