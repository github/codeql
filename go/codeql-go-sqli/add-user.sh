#!/bin/bash
get-user-info () {
    echo "*** Welcome to sql injection ***"
    read -r -p "Please enter name: " NAME
}

get-new-id () {
    ID=$(/bin/bash -c 'echo $$')
}

add-user-info () {
    echo "
    INSERT INTO users VALUES ($ID, '$NAME')
    " | sqlite3 users.sqlite 
}

show-user-info () {
    echo "We have the following information for you:"
    echo "
    select * FROM users where user_id=$ID
    " | sqlite3 users.sqlite 
}

get-user-info
get-new-id
add-user-info
show-user-info
