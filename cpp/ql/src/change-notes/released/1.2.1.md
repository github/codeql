## 1.2.1

### Minor Analysis Improvements

* The `cpp/uncontrolled-allocation-size` ("Uncontrolled allocation size") query now considers arithmetic operations that might reduce the size of user input as a barrier. The query therefore produces fewer false positive results.
