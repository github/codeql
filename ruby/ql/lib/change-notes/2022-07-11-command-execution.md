---
category: minorAnalysis
---
* Fixed a bug causing every expression in the database to be considered a system-command execution sink when calls to any of the following methods exist:
  * The `spawn`, `fspawn`, `popen4`, `pspawn`, `system`, `_pspawn` methods and the backtick operator from the `POSIX::spawn` gem.
  * The `execute_command`, `rake`, `rails_command`, and `git` methods in `Rails::Generation::Actions`.
