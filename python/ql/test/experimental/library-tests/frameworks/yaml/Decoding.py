import yaml
from yaml import SafeLoader

yaml.load(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=YAML $decodeMayExecuteInput
yaml.load(payload, Loader=SafeLoader)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=YAML
yaml.load(payload, Loader=yaml.BaseLoader)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=YAML
