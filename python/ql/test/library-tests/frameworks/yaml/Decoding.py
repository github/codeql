import yaml

# Unsafe:
yaml.load(payload)  # $decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML decodeMayExecuteInput
yaml.load(stream=payload)  # $decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML decodeMayExecuteInput
yaml.load(payload, yaml.Loader)  # $decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML decodeMayExecuteInput
yaml.unsafe_load(payload) # $ decodeInput=payload decodeOutput=yaml.unsafe_load(..) decodeFormat=YAML decodeMayExecuteInput
yaml.full_load(payload) # $ decodeInput=payload decodeOutput=yaml.full_load(..) decodeFormat=YAML decodeMayExecuteInput

# Safe:
yaml.load(payload, yaml.SafeLoader)  # $ decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML
yaml.load(payload, Loader=yaml.SafeLoader)  # $decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML
yaml.load(payload, yaml.BaseLoader)  # $decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML
yaml.safe_load(payload) # $ decodeInput=payload decodeOutput=yaml.safe_load(..) decodeFormat=YAML

################################################################################
# load_all variants
################################################################################

# Unsafe:
yaml.load_all(payload) # $ decodeInput=payload decodeOutput=yaml.load_all(..) decodeFormat=YAML decodeMayExecuteInput
yaml.unsafe_load_all(payload) # $ decodeInput=payload decodeOutput=yaml.unsafe_load_all(..) decodeFormat=YAML decodeMayExecuteInput
yaml.full_load_all(payload) # $ decodeInput=payload decodeOutput=yaml.full_load_all(..) decodeFormat=YAML decodeMayExecuteInput

# Safe:
yaml.safe_load_all(payload) # $ decodeInput=payload decodeOutput=yaml.safe_load_all(..) decodeFormat=YAML

################################################################################
# C-based loaders with `libyaml`
################################################################################

# Unsafe:
yaml.load(payload, yaml.CLoader)  # $ decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML decodeMayExecuteInput
yaml.load(payload, yaml.CFullLoader)  # $ decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML decodeMayExecuteInput

# Safe:
yaml.load(payload, yaml.CSafeLoader)  # $decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML
yaml.load(payload, yaml.CBaseLoader)  # $decodeInput=payload decodeOutput=yaml.load(..) decodeFormat=YAML
