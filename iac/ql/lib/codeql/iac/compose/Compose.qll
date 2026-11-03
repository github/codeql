private import codeql.iac.YAML
private import codeql.files.FileSystem

module Compose {
  /**
   * A Compose file node.
   */
  private class Node extends YamlNode {
    Node() {
      this.getFile().getBaseName() =
        [
          // Compose
          "compose.yml", "compose.yaml",
          // Docker
          "docker-compose.yml", "docker-compose.yaml",
          // Podman
          "podman-compose.yml", "podman-compose.yaml",
        ]
    }
  }

  /**
   * Docker / Podman Compose file.
   */
  class Document extends Node, YamlDocument, YamlMapping {
    /**
     * Gets the version of the Compose file, if any.
     */
    string getApiVersion() {
      result = this.lookup("version").toString().regexpReplaceAll("('|\")", "")
    }

    /**
     * Gets a service defined in the Compose file, if any.
     */
    Service getAService() { result = this.lookup("services").getAChildNode() }

    /**
     * Gets a service defined in the Compose file, if any.
     *
     * Use `getAService` instead.
     */
    Service getServices() { result = this.getAService() }

    /**
     * Gets the network definitions, if any.
     */
    YamlValue getNetworks() { result = this.lookup("networks") }

    /**
     * Gets the volume definitions, if any.
     */
    YamlValue getVolumes() { result = this.lookup("volumes") }

    /**
     * Gets the secret definitions, if any.
     */
    YamlValue getSecrets() { result = this.lookup("secrets") }
  }

  /**
   * A service defined in a Compose file.
   */
  class Service extends YamlMapping {
    Document compose;

    /**
     * Compose Service
     */
    Service() { compose.lookup("services").getAChildNode() = this }

    /**
     * Gets the name of the service.
     */
    string getName() {
      exists(YamlMapping services, YamlValue key, YamlValue value |
        services = compose.lookup("services") and
        services.maps(key, value) and
        value = this and
        result = yamlToString(key)
      )
    }

    /**
     * Gets the explicit container name, if any.
     */
    string getContainerName() { result = yamlToString(this.lookup("container_name")) }

    /**
     * Gets the container image, if any.
     */
    string getImage() { result = yamlToString(this.lookup("image")) }

    /**
     * Gets the build configuration, if any.
     */
    YamlValue getBuild() { result = this.lookup("build") }

    /**
     * Gets the environment definition, if any.
     */
    YamlValue getEnvironment() { result = this.lookup("environment") }

    /**
     * Gets an environment entry, if any.
     */
    EnvironmentEntry getAnEnvironmentEntry() {
      result = this.lookup("environment").(YamlSequence).getAChild()
      or
      this.lookup("environment").(YamlMapping).maps(result, _)
    }

    /**
     * Gets the secret references, if any.
     */
    YamlValue getSecrets() { result = this.lookup("secrets") }

    /**
     * Gets the volume mounts, if any.
     */
    YamlValue getVolumes() { result = this.lookup("volumes") }

    /**
     * Gets the capabilities to add, if any.
     */
    YamlValue getCapAdd() { result = this.lookup("cap_add") }

    /**
     * Gets the capabilities to drop, if any.
     */
    YamlValue getCapDrop() { result = this.lookup("cap_drop") }

    /**
     * Gets the privileged setting, if any.
     */
    YamlValue getPrivileged() { result = this.lookup("privileged") }

    /**
     * Gets the read-only root filesystem setting, if any.
     */
    YamlValue getReadOnly() { result = this.lookup("read_only") }

    /**
     * Gets the user setting, if any.
     */
    YamlValue getUser() { result = this.lookup("user") }

    /**
     * Gets the PID mode, if any.
     */
    YamlValue getPid() { result = this.lookup("pid") }

    /**
     * Gets the network mode, if any.
     */
    YamlValue getNetworkMode() { result = this.lookup("network_mode") }

    /**
     * Gets the device mappings, if any.
     */
    YamlValue getDevices() { result = this.lookup("devices") }
  }

  /**
   * An environment entry defined for a Compose service.
   */
  class EnvironmentEntry extends YamlValue {
    EnvironmentEntry() {
      exists(Service service | service.lookup("environment").(YamlSequence).getAChild() = this)
      or
      exists(Service service, YamlValue value |
        service.lookup("environment").(YamlMapping).maps(this, value)
      )
    }

    /**
     * Gets the environment variable name.
     */
    string getName() {
      exists(Service service, YamlValue value |
        service.lookup("environment").(YamlMapping).maps(this, value) and
        result = yamlToString(this)
      )
      or
      result = this.(YamlString).getValue().regexpCapture("([^=]+)=.*", 1)
      or
      result = this.(YamlString).getValue() and
      not result.matches("%=%")
    }

    /**
     * Gets the environment variable value.
     */
    YamlValue getValue() {
      exists(Service service | service.lookup("environment").(YamlMapping).maps(this, result))
      or
      exists(Service service |
        service.lookup("environment").(YamlSequence).getAChild() = this and
        result = this
      )
    }
  }
}
