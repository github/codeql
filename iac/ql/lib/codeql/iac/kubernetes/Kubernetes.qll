private import codeql.iac.YAML
private import codeql.files.FileSystem

/**
 * Structural model for Kubernetes YAML manifests.
 *
 * The model intentionally covers locally observable workload and RBAC
 * structure. It does not attempt to resolve admission policies, rendered Helm
 * values, or cluster-level defaults.
 */
module YamlKubernetes {
  class Document extends YamlNode, YamlDocument, YamlMapping {
    Document() {
      this.getFile().getExtension() = ["yml", "yaml"] and
      exists(this.lookup("apiVersion")) and
      exists(this.lookup("kind")) and
      this.lookup("kind").(YamlString).getValue() != "Chart"
    }

    override string toString() { result = "Kubernetes " + this.getKind() + " document" }

    /**
     * Gets the Kubernetes API version.
     */
    string getApiVersion() { result = yamlToString(this.lookup("apiVersion")) }

    /**
     * Gets the Kubernetes resource kind.
     */
    string getKind() { result = yamlToString(this.lookup("kind")) }

    /**
     * Gets the resource metadata, if any.
     */
    Metadata getMetadata() { result = this.lookup("metadata") }

    /**
     * Gets the resource specification, if any.
     */
    YamlMapping getSpec() { result = this.lookup("spec") }

    /**
     * Gets the pod specification, if any.
     */
    PodSpec getPodSpec() { result.getDocument() = this }

    /**
     * Gets a regular container, if any.
     */
    Container getAContainer() { result = this.getPodSpec().getAContainer() }

    /**
     * Gets an init container, if any.
     */
    Container getAnInitContainer() { result = this.getPodSpec().getAnInitContainer() }

    /**
     * Gets an ephemeral container, if any.
     */
    Container getAnEphemeralContainer() { result = this.getPodSpec().getAnEphemeralContainer() }
  }

  class Metadata extends YamlNode, YamlMapping {
    Metadata() { exists(Document document | document.lookup("metadata") = this) }

    /**
     * Gets the resource name, if any.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the resource namespace, if any.
     */
    string getNamespace() { result = yamlToString(this.lookup("namespace")) }

    /**
     * Gets the resource labels, if any.
     */
    YamlValue getLabels() { result = this.lookup("labels") }

    /**
     * Gets the resource annotations, if any.
     */
    YamlValue getAnnotations() { result = this.lookup("annotations") }
  }

  class PodSpec extends YamlNode, YamlMapping {
    PodSpec() {
      exists(Document document |
        document.getKind() = "Pod" and
        document.lookup("spec") = this
      )
      or
      exists(Document document |
        document.getKind() =
          ["DaemonSet", "Deployment", "Job", "ReplicaSet", "ReplicationController", "StatefulSet",] and
        document.lookup("spec").(YamlMapping).lookup("template").(YamlMapping).lookup("spec") = this
      )
      or
      exists(Document document |
        document.getKind() = "CronJob" and
        document
            .lookup("spec")
            .(YamlMapping)
            .lookup("jobTemplate")
            .(YamlMapping)
            .lookup("spec")
            .(YamlMapping)
            .lookup("template")
            .(YamlMapping)
            .lookup("spec") = this
      )
    }

    /**
     * Gets a regular container, if any.
     */
    Container getAContainer() { result = this.lookup("containers").(YamlSequence).getAChild() }

    /**
     * Gets an init container, if any.
     */
    Container getAnInitContainer() {
      result = this.lookup("initContainers").(YamlSequence).getAChild()
    }

    /**
     * Gets an ephemeral container, if any.
     */
    Container getAnEphemeralContainer() {
      result = this.lookup("ephemeralContainers").(YamlSequence).getAChild()
    }

    /**
     * Gets the pod security context, if any.
     */
    SecurityContext getSecurityContext() { result = this.lookup("securityContext") }

    /**
     * Gets the service account name, if any.
     */
    YamlValue getServiceAccountName() { result = this.lookup("serviceAccountName") }

    /**
     * Gets the service account token automount setting, if any.
     */
    YamlValue getAutomountServiceAccountToken() {
      result = this.lookup("automountServiceAccountToken")
    }

    /**
     * Gets a volume, if any.
     */
    Volume getAVolume() { result = this.lookup("volumes").(YamlSequence).getAChild() }

    /**
     * Gets the host network setting, if any.
     */
    YamlValue getHostNetwork() { result = this.lookup("hostNetwork") }

    /**
     * Gets the host PID namespace setting, if any.
     */
    YamlValue getHostPid() { result = this.lookup("hostPID") }

    /**
     * Gets the host IPC namespace setting, if any.
     */
    YamlValue getHostIpc() { result = this.lookup("hostIPC") }
  }

  class Container extends YamlNode, YamlMapping {
    Container() {
      exists(PodSpec pod | pod.lookup("containers").(YamlSequence).getAChildNode() = this)
      or
      exists(PodSpec pod | pod.lookup("initContainers").(YamlSequence).getAChildNode() = this)
      or
      exists(PodSpec pod | pod.lookup("ephemeralContainers").(YamlSequence).getAChildNode() = this)
    }

    /**
     * Gets the container name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the container image, if any.
     */
    string getImage() { result = yamlToString(this.lookup("image")) }

    /**
     * Gets the container security context, if any.
     */
    SecurityContext getSecurityContext() { result = this.lookup("securityContext") }

    /**
     * Gets the container command, if any.
     */
    YamlValue getCommand() { result = this.lookup("command") }

    /**
     * Gets the container arguments, if any.
     */
    YamlValue getArgs() { result = this.lookup("args") }

    /**
     * Gets the environment variable definitions, if any.
     */
    YamlValue getEnv() { result = this.lookup("env") }

    /**
     * Gets an environment entry, if any.
     */
    EnvEntry getAnEnvironmentEntry() { result = this.lookup("env").(YamlSequence).getAChild() }

    /**
     * Gets the environment sources, if any.
     */
    YamlValue getEnvFrom() { result = this.lookup("envFrom") }

    /**
     * Gets the volume mounts, if any.
     */
    YamlValue getVolumeMounts() { result = this.lookup("volumeMounts") }

    /**
     * Gets the container ports, if any.
     */
    YamlValue getPorts() { result = this.lookup("ports") }
  }

  class EnvEntry extends YamlNode, YamlMapping {
    EnvEntry() {
      exists(Container container | container.lookup("env").(YamlSequence).getAChildNode() = this)
    }

    /**
     * Gets the environment variable name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the literal environment variable value, if any.
     */
    YamlValue getValue() { result = this.lookup("value") }

    /**
     * Gets the environment variable value source, if any.
     */
    YamlMapping getValueFrom() { result = this.lookup("valueFrom") }

    /**
     * Gets the referenced secret key, if any.
     */
    YamlMapping getSecretKeyRef() { result = this.getValueFrom().lookup("secretKeyRef") }

    /**
     * Gets the referenced ConfigMap key, if any.
     */
    YamlMapping getConfigMapKeyRef() { result = this.getValueFrom().lookup("configMapKeyRef") }
  }

  class SecurityContext extends YamlNode, YamlMapping {
    SecurityContext() {
      exists(PodSpec pod | pod.lookup("securityContext") = this)
      or
      exists(Container container | container.lookup("securityContext") = this)
    }

    /**
     * Gets the privileged setting, if any.
     */
    YamlValue getPrivileged() { result = this.lookup("privileged") }

    /**
     * Gets the privilege escalation setting, if any.
     */
    YamlValue getAllowPrivilegeEscalation() { result = this.lookup("allowPrivilegeEscalation") }

    /**
     * Gets the user ID, if any.
     */
    YamlValue getRunAsUser() { result = this.lookup("runAsUser") }

    /**
     * Gets the group ID, if any.
     */
    YamlValue getRunAsGroup() { result = this.lookup("runAsGroup") }

    /**
     * Gets the non-root user requirement, if any.
     */
    YamlValue getRunAsNonRoot() { result = this.lookup("runAsNonRoot") }

    /**
     * Gets the read-only root filesystem setting, if any.
     */
    YamlValue getReadOnlyRootFilesystem() { result = this.lookup("readOnlyRootFilesystem") }

    /**
     * Gets the Linux capabilities configuration, if any.
     */
    YamlValue getCapabilities() { result = this.lookup("capabilities") }

    /**
     * Gets the seccomp profile, if any.
     */
    YamlValue getSeccompProfile() { result = this.lookup("seccompProfile") }
  }

  class Volume extends YamlNode, YamlMapping {
    Volume() { exists(PodSpec pod | pod.lookup("volumes").(YamlSequence).getAChildNode() = this) }

    /**
     * Gets the volume name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the host path volume source, if any.
     */
    YamlValue getHostPath() { result = this.lookup("hostPath") }

    /**
     * Gets the projected volume source, if any.
     */
    YamlValue getProjected() { result = this.lookup("projected") }

    /**
     * Gets the secret volume source, if any.
     */
    YamlValue getSecret() { result = this.lookup("secret") }

    /**
     * Gets the ConfigMap volume source, if any.
     */
    YamlValue getConfigMap() { result = this.lookup("configMap") }
  }

  class Role extends Document {
    Role() { this.getKind() = ["Role", "ClusterRole"] }

    /**
     * Gets an RBAC rule, if any.
     */
    Rule getARule() { result = this.lookup("rules").(YamlSequence).getAChild() }
  }

  class Rule extends YamlNode, YamlMapping {
    Rule() { exists(Role role | role.lookup("rules").(YamlSequence).getAChildNode() = this) }

    /**
     * Gets the API groups, if any.
     */
    YamlValue getApiGroups() { result = this.lookup("apiGroups") }

    /**
     * Gets the resources, if any.
     */
    YamlValue getResources() { result = this.lookup("resources") }

    /**
     * Gets the allowed verbs, if any.
     */
    YamlValue getVerbs() { result = this.lookup("verbs") }

    /**
     * Gets the resource names, if any.
     */
    YamlValue getResourceNames() { result = this.lookup("resourceNames") }
  }

  class RoleBinding extends Document {
    RoleBinding() { this.getKind() = ["RoleBinding", "ClusterRoleBinding"] }

    /**
     * Gets the referenced role.
     */
    YamlMapping getRoleRef() { result = this.lookup("roleRef") }

    /**
     * Gets a binding subject, if any.
     */
    Subject getASubject() { result = this.lookup("subjects").(YamlSequence).getAChild() }
  }

  class Subject extends YamlNode, YamlMapping {
    Subject() {
      exists(RoleBinding binding | binding.lookup("subjects").(YamlSequence).getAChildNode() = this)
    }

    /**
     * Gets the subject kind.
     */
    string getKind() { result = yamlToString(this.lookup("kind")) }

    /**
     * Gets the subject name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Gets the subject namespace, if any.
     */
    string getNamespace() { result = yamlToString(this.lookup("namespace")) }
  }
}
