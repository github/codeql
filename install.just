import 'lib.just'

@_install LANGUAGE:
    cd {{ source_dir() }}; bazel run //{{ trim_end_match(LANGUAGE, '/') }}:install

[group('build')]
install LANGUAGE: (_install LANGUAGE)

alias i := install
