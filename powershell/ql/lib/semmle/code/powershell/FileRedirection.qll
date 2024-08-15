import powershell

class FileRedirection extends @file_redirection, Redirection {
  override string toString() { result = "FileRedirection" }

  override Location getLocation() { file_redirection_location(this, result) }
}
