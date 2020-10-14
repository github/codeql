import yaml
from yaml import SafeLoader

yaml.load(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=YAML $decodeUnsafe
yaml.load(payload, Loader=SafeLoader)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=YAML
