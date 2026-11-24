import rust

from Function f
where f.getFile().getBaseName() = "only_a.rs"
select f, f.getName()
