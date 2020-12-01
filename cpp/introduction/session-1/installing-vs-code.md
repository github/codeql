

Hello, and welcome to this video explaining how to setup the CodeQL Extension for VS Code. My name is Luke Cartey, and I am a Security Solutions Architect in the Professional Services team at GitHub.

As you can see, I have already installed VS Code, and I have also installed the extension, by clicking on the extensions panel, searching for CodeQL and installing the extension.

To make it easy to get started with the extension, we have provided a "starter workspace", which is pre-configured so that all you need to do is clone the repository and open the workspace file. To do this, I've opened the terminal window in VS Code, and ran git clone --recursive with the repository into a new directory I've created for the purpose.

Having cloned the repository, we can now open it by using the command palette (Ctrl + Shift + p if you are unfamiliar with VS Code), and selecting open workspace, then select the vscode-codeql-starter.code-workspace file.

The starter workspace comes with directories for writing queries in each of the supported in languages, plus a checkout of the standard libraries for CodeQL.

The final step is import a database to write queries. We will import an Exiv2 database, which I've already downloaded. If open the terminal window again, switch to my directory, we can see that we have the zip file here. We need to unzip it from a terminal (or from a file browser), then we can import it into VS Code by selecting the command palette again and going "Choose Database".

Now the database has been imported, we can switch to the CodeQL panel here, and we can see our database has been selected. We can right click on the database for more options. This database was created with an older version of our toolchain, so it can also be upgraded here, which will be required for running queries on it.

We are now all set to write some queries!
