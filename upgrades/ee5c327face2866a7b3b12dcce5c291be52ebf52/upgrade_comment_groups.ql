class File extends @file {
  string toString() { result = "file" }
}

class Location extends @location {
  /** Gets the file for this location. */
  File getFile() { locations_default(this, result, _, _, _, _) }

  int getStartLine() { locations_default(this, _, result, _, _, _) }

  string toString() { result = "location" }
}

class Locatable extends @locatable {
  Location getLocation() { has_location(this, result) }

  string toString() { result = "locatable" }
}

class CommentGroup extends @comment_group, Locatable {
  Comment getComment(int i) { comments(result, _, this, i, _) }

  override string toString() { result = "comment group" }
}

class Comment extends @comment, Locatable {
  override string toString() { result = "comment" }
}

Location getLocation(CommentGroup cg) {
  result = cg.getLocation()
  or
  not exists(cg.getLocation()) and result = cg.getComment(0).getLocation()
}

from CommentGroup cg, File f, int idx
where
  f = getLocation(cg).getFile() and
  rank[idx + 1](CommentGroup rankedcg |
    getLocation(rankedcg).getFile() = f
  |
    rankedcg order by getLocation(rankedcg).getStartLine()
  ) = cg
select cg, f, idx
