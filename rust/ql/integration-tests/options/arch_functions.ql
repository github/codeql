import rust

from Function f
where f.getLocation().getFile().getBaseName() = "arch.rs" and f.hasExtendedCanonicalPath()
select f
