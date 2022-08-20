lgtm,codescanning
* Improved modeling of `django` to recognize QuerySet chains such as `User.objects.using("db-name").exclude(username="admin").extra("some sql")`. This can lead to new results for `py/sql-injection`.
