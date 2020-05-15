# Improvements to Java analysis

The following changes in version 1.25 affect Java analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|


## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|


## Changes to libraries

* The data-flow library has been improved, which affects most security queries by potentially
  adding more results. Flow through methods now takes nested field reads/writes into account.
  For example, the library is able to track flow from `"taint"` to `sink()` via the method
  `getF2F1()` in
  ```java
  class C1 {
    String f1;
    C1(String f1) { this.f1 = f1; }
  }

  class C2 {
    C1 f2;
    String getF2F1() {
        return this.f2.f1; // Nested field read
    }
    void m() {
        this.f2 = new C1("taint");
        sink(this.getF2F1()); // NEW: "taint" reaches here
    }
  }
  ```
