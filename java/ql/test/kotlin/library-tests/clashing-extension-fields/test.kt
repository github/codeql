package packagename.subpackagename

public class A { }
public class B { }

val A.x : String by lazy { "HelloA" }
val B.x : String by lazy { "HelloB" }
