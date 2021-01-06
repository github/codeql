Publishing this project for a new version
#########################################

To update this project for a new version:

1. Check with the language teams that all information in the ``ql/change-notes/support/`` directory is ready.

2. Open the ``global-conf.py`` file in the ``global-sphinx-files`` directory and change the following variables 
to the correct value(s) if necessary:

    * ``version =``
    * ``release = ``
    * If it's the first release of the year, ``copyright =``

3. Commit your changes. The output of the ``doc/sphinx`` PR check should be correct for the new version and ready to publish.