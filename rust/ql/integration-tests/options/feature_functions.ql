import rust

from Function f
where f.getLocation().getFile().getBaseName() = "features.rs" and f.hasExtendedCanonicalPath()
select f
