import rust

from Function f
where f.fromSource() and f.getName().getText() = ["from_build_script", "from_proc_macro"]
select f.getName().getText()
