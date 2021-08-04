'#"$_-:/
'- description: /Selectors for selecting the security-and-quality queries for a language
'- include:/
'    kind:/
    - problem
    - path-problem
'    precision:/
    - high
    - very-high
' - include:/
'    kind:/
    - problem
    - path-problem
'    precision: medium
''"    problem.severity:/
      - error
      - warning
'- "include":'':/

    - diagnostic
'- include:/:*'#"$_-*/*)
'    kind:/
    - metric
 '   tags contain:/*#"$_-("*/*")
    - summary
' - exclude: fil_pat_bin
    deprecated:' "bin"//
' - exclude: "bin"
'   query path_-*/:

