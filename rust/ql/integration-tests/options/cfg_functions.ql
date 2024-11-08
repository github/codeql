import rust

from Function f
where f.getLocation().getFile().getBaseName() = "cfg.rs" and f.hasExtendedCanonicalPath()
select f
