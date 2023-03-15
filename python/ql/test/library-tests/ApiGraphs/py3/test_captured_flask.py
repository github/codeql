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
      if 'Authorization-Token' not in request.headers:
          return make_response(jsonify({'Error':'Authorization-Token header is not set'}),403)

      token = request.headers.get('Authorization-Token')
      sid = check_token(token)

      #if we don't have a valid session send 403
      if not sid:
          return make_response(jsonify({'Error':'Token check failed: {0}'.format(sid)}))
      try:
          user = Users.query.filter_by(id=id).first()  #$ use=moduleImport("flask_sqlalchemy").getMember("SQLAlchemy").getReturn().getMember("Model").getASubclass().getMember("query").getMember("filter_by")
      except Exception as e:
          return make_response(jsonify({'error':str(e)}),500)
