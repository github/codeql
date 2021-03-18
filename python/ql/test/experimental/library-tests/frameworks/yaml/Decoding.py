import yaml

# Unsafe:
yaml.load(payload)  # $decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.load(payload, yaml.Loader)  # $decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.unsafe_load(payload) # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.full_load(payload) # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput

# Safe
yaml.load(payload, yaml.SafeLoader)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML
yaml.load(payload, Loader=yaml.SafeLoader)  # $decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML
yaml.load(payload, yaml.BaseLoader)  # $decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML
yaml.safe_load(payload) # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML

# load_all variants
yaml.load_all(payload) # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.safe_load_all(payload) # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML
yaml.unsafe_load_all(payload) # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.full_load_all(payload) # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
