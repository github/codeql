Finding a CodeQL database to experiment with
--------------------------------------------

Before you start writing queries for |language-text| code, you need a CodeQL database to run them against. The simplest way to do this is to download a database for a repository that uses |language-text| directly from GitHub.com.

#. In Visual Studio Code, click the **QL** icon |codeql-ext-icon| in the left sidebar to display the CodeQL extension. 

#. Click **From GitHub** or the GitHub logo |github-db| at the top of the CodeQL extension to open an entry field.

#. Copy the URL for the repository into the field and press the keyboard **Enter** key. For example, |example-url|.

#. Optionally, if the repository has more than one CodeQL database available, select |language-code| to download the database created from the |language-text| code. 

Information about the download progress for the database is shown in the bottom right corner of Visual Studio Code. When the download is complete, the database is shown with a check mark in the **Databases** section of the CodeQL extension (see screenshot below).

.. |codeql-ext-icon| image:: ../images/codeql-for-visual-studio-code/codeql-extension-icon.png
  :width: 20
  :alt: Icon for the CodeQL extension.

.. |github-db| image:: ../images/codeql-for-visual-studio-code/add-codeql-db-github.png
  :width: 20
  :alt: Icon for the CodeQL extension option to download a CodeQL database from GitHub.

