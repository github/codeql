private import iac

query predicate documents(YamlKubernetes::Document n) { any() }

query predicate metadata(YamlKubernetes::Metadata n) { any() }

query predicate podSpecs(YamlKubernetes::PodSpec n) { any() }

query predicate containers(YamlKubernetes::Container n) { any() }

query predicate env(YamlKubernetes::EnvEntry n) { any() }

query predicate security(YamlKubernetes::SecurityContext n) { any() }

query predicate volumes(YamlKubernetes::Volume n) { any() }

query predicate roles(YamlKubernetes::Role n) { any() }

query predicate rules(YamlKubernetes::Rule n) { any() }

query predicate bindings(YamlKubernetes::RoleBinding n) { any() }

query predicate subjects(YamlKubernetes::Subject n) { any() }

query predicate documentContainers(YamlKubernetes::Document d, YamlKubernetes::Container container) {
  container = d.getAContainer()
}

query predicate podContainers(YamlKubernetes::PodSpec pod, YamlKubernetes::Container container) {
  container = pod.getAContainer()
}

query predicate podVolumes(YamlKubernetes::PodSpec pod, YamlKubernetes::Volume volume) {
  volume = pod.getAVolume()
}

query predicate containerEnvironment(
  YamlKubernetes::Container container, YamlKubernetes::EnvEntry entry
) {
  entry = container.getAnEnvironmentEntry()
}

query predicate roleRules(YamlKubernetes::Role role, YamlKubernetes::Rule rule) {
  rule = role.getARule()
}

query predicate bindingSubjects(YamlKubernetes::RoleBinding binding, YamlKubernetes::Subject subject) {
  subject = binding.getASubject()
}
