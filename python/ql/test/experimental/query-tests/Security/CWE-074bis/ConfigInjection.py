from configparser import RawConfigParser, ConfigParser
from flask import Flask, request, render_template
import re

app = Flask(__name__)


@app.route("/unsafe1")
def unsafe1():
    # Retriev the user input
    user_input = request.args.get("ui")

    # Create an instance of RawConfigParser
    config = RawConfigParser()

    # Add some configuration data
    config.add_section("Section1")
    config.set("Section1", "key1", "value1")
    config.set("Section1", "key2", user_input)  # $result=BAD

    config.add_section("Section2")
    config.set("Section2", "key3", "value3")
    config.set("Section2", "key4", "value4")

    # Write the configuration data to a file
    with open("config.ini", "w") as configfile:
        config.write(configfile)
        print("Configuration file has been written successfully.")

    # Read the configuration data from the file
    config = RawConfigParser()
    config.read("config.ini")

    # Access the values
    result = ""
    for section in config.sections():
        result += f"<ul><b>{section}</b> </ul>"
        for key in config[section]:
            result += f"<li><b>{key}</b>: {config[section][key]} </li>"

    return render_template(
        "result.html",
        ui=result,
    )


@app.route("/unsafe2")
def unsafe2():
    # Retriev the user input
    user_input = request.args.get("ui")

    # Create an instance of RawConfigParser
    config = ConfigParser()

    # Add some configuration data
    config.add_section("Section1")
    config.set("Section1", "key1", "value1")
    config.set("Section1", "key2", user_input)  # $result=BAD

    config.add_section("Section2")
    config.set("Section2", "key3", "value3")
    config.set("Section2", "key4", "value4")

    # Write the configuration data to a file
    with open("config.ini", "w") as configfile:
        config.write(configfile)
        print("Configuration file has been written successfully.")

    # Read the configuration data from the file
    config = ConfigParser()
    config.read("config.ini")

    # Access the values
    result = ""
    for section in config.sections():
        result += f"<ul><b>{section}</b> </ul>"
        for key in config[section]:
            result += f"<li><b>{key}</b>: {config[section][key]} </li>"

    return render_template(
        "result.html",
        ui=result,
    )


@app.route("/unsafe3")
def unsafe3():
    # Retriev the user input
    user_input = request.args.get("ui")

    # Create an instance of RawConfigParser
    config = RawConfigParser()

    # Add some configuration data
    config.add_section("Section1")
    config.set("Section1", "key1", "value1")
    config.set("Section1", "key2", "value2")

    # malicious payload like Section2]\rkey5=value5\rkey6=value6
    config.add_section(user_input)  # $result=BAD

    # Write the configuration data to a file
    with open("config.ini", "w") as configfile:
        config.write(configfile)
        print("Configuration file has been written successfully.")

    # Read the configuration data from the file
    config = RawConfigParser()
    config.read("config.ini")

    # Access the values
    result = ""
    for section in config.sections():
        result += f"<ul><b>{section}</b> </ul>"
        for key in config[section]:
            result += f"<li><b>{key}</b>: {config[section][key]} </li>"

    return render_template(
        "result.html",
        ui=result,
    )


class MyConfigParser(RawConfigParser):
    def __init__(self):
        super().__init__()

    def add_section(self, section: str) -> None:
        return super().add_section(section)

    def set(self, section: str, option: str, value: str | None = None) -> None:
        return super().set(section, option, value)


@app.route("/unsafe4")
def unsafe4():
    # Retriev the user input
    user_input = request.args.get("ui")

    # Create an instance of RawConfigParser
    config = MyConfigParser()

    # Add some configuration data
    config.add_section("Section1")
    config.set("Section1", "key1", "value1")
    config.set("Section1", "key2", "value2")

    # malicious payload like value5\rkey6=value6
    config.add_section("Section3")
    config.set("Section3", "key5", user_input)  # $result=BAD

    # Write the configuration data to a file
    with open("config.ini", "w") as configfile:
        config.write(configfile)
        print("Configuration file has been written successfully.")

    # Read the configuration data from the file
    config = MyConfigParser()
    config.read("config.ini")

    # Access the values
    result = ""
    for section in config.sections():
        result += f"<ul><b>{section}</b> </ul>"
        for key in config[section]:
            result += f"<li><b>{key}</b>: {config[section][key]} </li>"

    return render_template(
        "result.html",
        ui=result,
    )


@app.route("/safe1")
def unsafe1():
    # Retriev the user input
    user_input = request.args.get("ui")

    # Sanitize using str.replace()
    user_input = user_input.replace("\r", "")

    # Create an instance of RawConfigParser
    config = RawConfigParser()

    # Add some configuration data
    config.add_section("Section1")
    config.set("Section1", "key1", "value1")
    config.set("Section1", "key2", user_input)  # $result=OK

    config.add_section("Section2")
    config.set("Section2", "key3", "value3")
    config.set("Section2", "key4", "value4")

    # Write the configuration data to a file
    with open("config.ini", "w") as configfile:
        config.write(configfile)
        print("Configuration file has been written successfully.")

    # Read the configuration data from the file
    config = RawConfigParser()
    config.read("config.ini")

    # Access the values
    result = ""
    for section in config.sections():
        result += f"<ul><b>{section}</b> </ul>"
        for key in config[section]:
            result += f"<li><b>{key}</b>: {config[section][key]} </li>"

    return render_template(
        "result.html",
        ui=result,
    )


@app.route("/safe2")
def unsafe1():
    # Retriev the user input
    user_input = request.args.get("ui")

    # Create an instance of RawConfigParser
    config = RawConfigParser()

    # sanitize using re.sub()
    user_input = re.sub("\r", "", user_input)

    # Add some configuration data
    config.add_section("Section1")
    config.set("Section1", "key1", "value1")
    config.set("Section1", "key2", user_input)  # $result=OK

    config.add_section("Section2")
    config.set("Section2", "key3", "value3")
    config.set("Section2", "key4", "value4")

    # Write the configuration data to a file
    with open("config.ini", "w") as configfile:
        config.write(configfile)
        print("Configuration file has been written successfully.")

    # Read the configuration data from the file
    config = RawConfigParser()
    config.read("config.ini")

    # Access the values
    result = ""
    for section in config.sections():
        result += f"<ul><b>{section}</b> </ul>"
        for key in config[section]:
            result += f"<li><b>{key}</b>: {config[section][key]} </li>"

    return render_template(
        "result.html",
        ui=result,
    )


@app.route("/")
def index():
    return render_template("index2.html")
