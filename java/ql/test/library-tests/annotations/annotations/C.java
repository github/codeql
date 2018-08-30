package annotations;

@Pair(left = @Ann(key = "Left"), right = @Ann(key = "Right"))
@Container(children = { @Ann(key = "On" + "e"), @Ann(key = "Two") })
public class C { }
