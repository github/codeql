import powershell

class MergingRedirection extends @merging_redirection, Redirection {
  override string toString() { result = "MergingRedirection" }

  override Location getLocation() { merging_redirection_location(this, result) }
}
