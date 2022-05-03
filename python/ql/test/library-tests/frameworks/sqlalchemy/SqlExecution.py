import sqlalchemy
from sqlalchemy import Column, Integer, String, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.pool import StaticPool
from sqlalchemy.orm import relationship, backref, sessionmaker, joinedload
from sqlalchemy.sql import text

engine = create_engine(
    'sqlite:///:memory:',
    echo=True,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool
)

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    name = Column(String)

Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

ed_user = User(name='ed')
ed_user2 = User(name='george')

session.add(ed_user)
session.add(ed_user2)

session.commit()

# Injection without requiring the text() taint-step
session.query(User).filter_by(name="some sql")  # $ MISSING: getSql="some sql"
session.scalar("some sql")  # $ getSql="some sql"
engine.scalar("some sql")  # $ getSql="some sql"
session.execute("some sql")  # $ getSql="some sql"

with engine.connect() as connection:
    connection.execute("some sql")  # $ getSql="some sql"

with engine.begin() as connection:
    connection.execute("some sql")  # $ getSql="some sql"

# Injection requiring the text() taint-step
t = text("some sql")  # $ constructedSql="some sql"
session.query(User).filter(t)
session.query(User).group_by(User.id).having(t)
session.query(User).group_by(t).first()
session.query(User).order_by(t).first()

query = select(User).where(User.name == t)  # $ MISSING: getSql=t
with engine.connect() as conn:
    conn.execute(query) # $ getSql=query
