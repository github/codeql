import javascript

from JSLintOptions options, string name, string value
where options.definesFlag(name, value)
select options, name, value
