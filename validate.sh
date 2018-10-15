#!/bin/bash

people_exists=$(ldapsearch -x -b ou=people,dc=example,dc=org -D cn=admin,dc=example,dc=org -w admin | grep -c "dn: ou=people,dc=example,dc=org")
if [ $people_exists -ne 1 ]; then
    echo "Error on creating the entry 'ou=people,dc=example,dc=org'."
    exit 1
fi

groups_exists=$(ldapsearch -x -b ou=groups,dc=example,dc=org -D cn=admin,dc=example,dc=org -w admin | grep -c "dn: ou=groups,dc=example,dc=org")
if [ $groups_exists -ne 1 ]; then
    echo "Error on creating the entry 'ou=groups,dc=example,dc=org'."
    exit 1
fi

user_exists=$(ldapsearch -x -b ou=people,dc=example,dc=org -D cn=admin,dc=example,dc=org -w admin | grep -c "dn: uid=jacksp,ou=people,dc=example,dc=org")
if [ $user_exists -ne 1 ]; then
    echo "Error on creating the entry 'uid=jacksp,ou=people,dc=example,dc=org'."
    exit 1
fi

attr_exists=$(ldapsearch -x -b uid=jacksp,ou=people,dc=example,dc=org -D cn=admin,dc=example,dc=org -w admin | grep -c "userPassword:: YmxhY2tfcGVhcmw=")
if [ $attr_exists -ne 1 ]; then
    echo "Error on creating the attribute userPassword for 'uid=jacksp,ou=people,dc=example,dc=org'."
    exit 1
fi

exit 0