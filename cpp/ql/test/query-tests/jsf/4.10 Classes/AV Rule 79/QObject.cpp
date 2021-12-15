struct QObject {
  QObject(QObject *parent);
  void setParent(QObject *parent);
};

struct DerivedFromQObject : public QObject {
  DerivedFromQObject(QObject *parent);
};

class MyQtUser {
  DerivedFromQObject *noParent, *constructorParent, *laterParent;

  MyQtUser(QObject *parent) {
    // This object sets its parent pointer to null and thus must be deleted
    // manually.
    noParent = new DerivedFromQObject(nullptr); // BAD [NOT DETECTED]

    // This object does not need to be deleted because it will be deleted by
    // its parent object when the time is right.
    constructorParent = new DerivedFromQObject(parent); // GOOD

    laterParent = new DerivedFromQObject(nullptr); // GOOD
    laterParent->setParent(parent);
  }
};
