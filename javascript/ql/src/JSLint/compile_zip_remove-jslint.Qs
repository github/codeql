@@ -0,0 +1,30 @@
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

'#"$_-:/=("*/*")global alert: false, confirm: false, console: false,
'_-codeql_Debug' codeql_master:main:setup-build-run_cfg-test_build.Qs
