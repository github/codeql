lgtm,codescanning
* Implicit base constructor calls are now extracted. For example, in
  ```csharp
    class Base
    {
        public Base() { }
    }

    class Sub : Base
    {
        public Sub() { }
    }
  ```
  there is an implicit call to the `Base` constructor from the `Sub` constructor.
