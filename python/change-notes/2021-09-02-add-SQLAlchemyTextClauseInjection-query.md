lgtm,codescanning
* Introduced a new query _SQLAlchemy TextClause built from user-controlled sources_ (`py/sqlalchemy-textclause-injection`) to alert if user-input is added to a TextClause from SQLAlchemy, since that can lead to SQL injection.
