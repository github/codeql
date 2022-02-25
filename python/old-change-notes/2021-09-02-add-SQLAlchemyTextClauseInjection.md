lgtm,codescanning
* Expanded the query _SQL query built from user-controlled sources_ (`py/sql-injection`) to alert if user-input is added to a TextClause from SQLAlchemy, since that can lead to SQL injection.
