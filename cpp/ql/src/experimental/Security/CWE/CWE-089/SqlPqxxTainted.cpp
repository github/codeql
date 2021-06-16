#include <iostream>
#include <stdexcept>
#include <pqxx/pqxx>

int main(int argc, char ** argv) {

    if (argc != 2) { 
        throw std::runtime_error("Give me a string!");
    }
    
    pqxx::connection c;
    pqxx::work w(c);

    // BAD
    char *userName = argv[1];
    char query1[1000] = {0};
    sprintf(query1, "SELECT UID FROM USERS where name = \"%s\"", userName);
    pqxx::row r = w.exec1(query1);
    w.commit();
    std::cout << r[0].as<int>() << std::endl;

    // GOOD
    pqxx::result r2 = w.exec("SELECT " + w.quote(argv[1]));
    w.commit();
    std::cout << r2[0][0].c_str() << std::endl;

    return 0;
}
