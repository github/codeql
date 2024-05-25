Tutorials:
- [pymongo](https://pymongo.readthedocs.io/en/stable/tutorial.html)
- [install mongodb](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/#std-label-install-mdb-community-macos)

I recommend creating a virtual environment with venv and then installing dependencies via
```
python -m pip --install -r requirements.txt
```

Start mongodb:
```
mongod --config /usr/local/etc/mongod.conf --fork
```
run flask app:
```
flask --app server run
```

Navigate to the root to see routes. For each route try to get the system to reveal the person in the database. If you know the name, you can just input it, but in some cases you can get to the person without knowing the name!
