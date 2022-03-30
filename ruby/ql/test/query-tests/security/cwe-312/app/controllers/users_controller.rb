class UsersController < ApplicationController
  def createLikeCall
    new_password = "043697b96909e03ca907599d6420555f"
    # BAD: plaintext password stored to database
    User.create(name: "U1", password: new_password)
    # BAD: plaintext password stored to database
    User.create({ name: "U1", password: new_password })
  end

  def updateLikeClassMethodCall
    new_password = "083c9e1da4cc0c2f5480bb4dbe6ff141"
    # BAD: plaintext password stored to database
    User.update(1, name: "U1", password: new_password)
    # BAD: plaintext password stored to database
    User.update([1, 2], [{name: "U1", password: new_password}, {name: "U2", password: new_password}])
  end

  def insertAllLikeCall
    new_password = "504d224a806cf8073cd14ef08242d422"
    # BAD: plaintext password stored to database
    User.insert_all([{name: "U1", password: new_password}, {name: "U2", password: new_password}])
  end

  def updateLikeInstanceMethodCall
    user = User.find(1)
    new_password = "7d6ae08394c3f284506dca70f05995f6"
    # BAD: plaintext password stored to database
    user.update(password: new_password)
    # BAD: plaintext password stored to database
    user.update({password: new_password})
  end

  def updateAttributeCall
    user = User.find(1)
    new_password = "ff295f8648a406c37fbe378377320e4c"
    # BAD: plaintext password stored to database
    user.update_attribute("password", new_password)
  end

  def assignAttributeCall
    user = User.find(1)
    new_password = "78ffbec583b546bd073efd898f833184"
    # BAD: plaintext password assigned to database field
    user.password = new_password
    user.save
  end

  def hashedPasswordAssign
    user = User.find(1)
    new_password = "3746e149bfe3d6ccc665c3620d81cd2e"
    hashed_password = hash_password(new_password)

    # GOOD: assigned value is hashed
    user.password = hashed_password
  end

  def fileWrites
    new_password = "0157af7c38cbdd24f1616de4e5321861"

    # BAD: plaintext password stored to disk
    IO.write("foo.txt", "password: #{new_password}\n")

    # BAD: plaintext password stored to disk
    File.new("bar.txt", "a").puts("password: #{new_password}")
  end

  def randomPasswordAssign
    user = User.find(1)
    random_password = SecureRandom.hex(20)
    # GOOD: the `random_password` value here looks like the hash of an unknown password
    user.password = random_password
    user.save
  end
end
