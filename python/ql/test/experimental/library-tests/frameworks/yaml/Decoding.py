import yaml
from yaml import SafeLoader

yaml.load(payload)  # $decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.load(payload, SafeLoader)  # $ decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML SPURIOUS: decodeMayExecuteInput
yaml.load(payload, Loader=SafeLoader)  # $decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML
yaml.load(payload, Loader=yaml.BaseLoader)  # $decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML

yaml.safe_load(payload) # $ MISSING: decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML
yaml.unsafe_load(payload) # $ MISSING: decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.full_load(payload) # $ MISSING: decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput

yaml.load_all(payload) # $ MISSING: decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.safe_load_all(payload) # $ MISSING: decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML
yaml.unsafe_load_all(payload) # $ MISSING: decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
yaml.full_load_all(payload) # $ MISSING: decodeInput=payload decodeOutput=Attribute() decodeFormat=YAML decodeMayExecuteInput
