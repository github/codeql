import 'lib.just'

@_build LANGUAGE:
    if [ -n "${SEMMLE_CODE:-}" ]; then \
      cd $SEMMLE_CODE; ./build target/intree/codeql-{{ LANGUAGE }}; \
    else \
      just install {{ LANGUAGE }}; \
    fi

[group('build')]
build LANGUAGE: (_build LANGUAGE)

alias b := build
