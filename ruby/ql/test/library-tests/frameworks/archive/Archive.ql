private import codeql.ruby.AST
private import codeql.ruby.frameworks.Archive

query predicate rubyZipFileOpens(RubyZip::RubyZipFileOpen f) { any() }

query predicate rubyZipFileNew(RubyZip::RubyZipFileNew f) { any() }
