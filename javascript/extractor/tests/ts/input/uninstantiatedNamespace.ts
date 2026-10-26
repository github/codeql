namespace Wrapper {

  namespace Empty {}
  namespace Comments {
    // foo
    /* bar */
  }
  namespace Outer {
    namespace Inner {}
  }
  namespace Outer2 {
    export namespace Inner {}
  }
  namespace Interfaces {
    interface I {
      x: number;
      foo(): number;
    }
  }

  namespace EmptyStatement {;}
  namespace EmptyBlock {{}}

  var x = [Empty, Comments, Outer, Outer2, Interfaces, EmptyStatement, EmptyBlock]
}
