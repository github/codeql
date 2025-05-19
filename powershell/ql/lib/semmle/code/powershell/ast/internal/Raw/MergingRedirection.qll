private import Raw

class MergingRedirection extends @merging_redirection, Redirection {
  override Location getLocation() { merging_redirection_location(this, result) }
}
