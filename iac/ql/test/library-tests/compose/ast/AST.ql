private import iac

query predicate documents(Compose::Document n) { any() }

query predicate services(Compose::Service n) { any() }

query predicate environment(Compose::EnvironmentEntry n) { any() }

query predicate documentServices(Compose::Document d, Compose::Service s) { s = d.getAService() }

query predicate serviceNames(Compose::Service s, string name) { name = s.getName() }

query predicate containerNames(Compose::Service s, string name) { name = s.getContainerName() }

query predicate environmentValues(Compose::EnvironmentEntry entry, string name, YamlValue value) {
  name = entry.getName() and
  value = entry.getValue()
}
