import 'lib.just'

@_build LANGUAGE:
  just install {{ LANGUAGE }};

[group('build')]
build LANGUAGE: (_build LANGUAGE)

alias b := build
