import codeql.ruby.AST

// Just enough to test that we extracted the Gemfile and the .gemspec file.
select any(Call c)
