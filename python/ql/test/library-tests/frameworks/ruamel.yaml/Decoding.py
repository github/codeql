import ruamel.yaml

# Unsafe:
ruamel.yaml.load(payload)  # $ decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML decodeMayExecuteInput
ruamel.yaml.load(stream=payload)  # $ decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML decodeMayExecuteInput
ruamel.yaml.load(payload, ruamel.yaml.Loader)  # $ decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML decodeMayExecuteInput

# Safe:
ruamel.yaml.load(payload, ruamel.yaml.SafeLoader)  # $  decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML
ruamel.yaml.load(payload, Loader=ruamel.yaml.SafeLoader)  # $ decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML
ruamel.yaml.load(payload, ruamel.yaml.BaseLoader)  # $ decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML
ruamel.yaml.safe_load(payload) # $  decodeInput=payload decodeOutput=ruamel.yaml.safe_load(..) decodeFormat=YAML

################################################################################
# load_all variants
################################################################################

# Unsafe:
ruamel.yaml.load_all(payload) # $  decodeInput=payload decodeOutput=ruamel.yaml.load_all(..) decodeFormat=YAML decodeMayExecuteInput

# Safe:
ruamel.yaml.safe_load_all(payload) # $  decodeInput=payload decodeOutput=ruamel.yaml.safe_load_all(..) decodeFormat=YAML

################################################################################
# C-based loaders with `libyaml`
################################################################################

# Unsafe:
ruamel.yaml.load(payload, ruamel.yaml.CLoader)  # $  decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML decodeMayExecuteInput

# Safe:
ruamel.yaml.load(payload, ruamel.yaml.CSafeLoader)  # $ decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML
ruamel.yaml.load(payload, ruamel.yaml.CBaseLoader)  # $ decodeInput=payload decodeOutput=ruamel.yaml.load(..) decodeFormat=YAML
