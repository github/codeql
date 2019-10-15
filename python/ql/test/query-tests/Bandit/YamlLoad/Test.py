import json
import yaml


def test_yaml_load():
    ystr = yaml.dump({'a': 1, 'b': 2, 'c': 3})
    y = yaml.load(ystr)
    yaml.dump(y)
    try:
        y = yaml.load(ystr, Loader=yaml.CSafeLoader)
    except AttributeError:
        # CSafeLoader only exists if you build yaml with LibYAML
        y = yaml.load(ystr, Loader=yaml.SafeLoader)


def test_json_load():
    # no issue should be found
    j = json.load("{}")
