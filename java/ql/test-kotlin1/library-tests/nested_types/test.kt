
import java.util.Stack;

// Diagnostic Matches: %Making use of Stack a raw type to avoid infinite recursion%

class MyType

fun foo1(x: List<List<List<List<MyType>>>>) { }

fun foo2(x: Stack<Stack<Stack<Stack<MyType>>>>) { }

class MkT<T> { }

fun foo3(x: MkT<MkT<MkT<MkT<MyType>>>>) { }


