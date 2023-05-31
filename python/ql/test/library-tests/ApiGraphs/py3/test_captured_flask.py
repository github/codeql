from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_user import UserMixin

def create_app():
  app = Flask(__name__)
  db = SQLAlchemy(app)  #$ use=moduleImport("flask_sqlalchemy").getMember("SQLAlchemy").getReturn()

  class Users(db.Model, UserMixin):  #$ use=moduleImport("flask_sqlalchemy").getMember("SQLAlchemy").getReturn().getMember("Model").getASubclass()
      __tablename__ = 'users'

  @app.route('/v2/user/<int:id>', methods=['GET','PUT'])
  def users(id):
      Users.query.filter_by(id=id).first()  #$ use=moduleImport("flask_sqlalchemy").getMember("SQLAlchemy").getReturn().getMember("Model").getASubclass().getMember("query").getMember("filter_by")
