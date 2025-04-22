private import Raw

class FileRedirection extends @file_redirection, Redirection {
  override Location getLocation() { file_redirection_location(this, result) }
}
