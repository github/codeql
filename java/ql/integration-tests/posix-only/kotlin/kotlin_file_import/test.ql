import java

from Method m
where m.getDeclaringType().getName() = "LongsigKt"
select m.getLocation()
      .toString()
      .regexpReplaceAll(".*(extlib.jar|!unknown-binary-location)/", "<prefix>/"), m.toString()
