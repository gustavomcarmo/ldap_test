#!/bin/bash

docker run --name openldap -d -p 389:389 osixia/openldap:1.2.1
if [ $? -ne 0 ]; then
    echo "Error on running the OpenLDAP Docker image."
    exit 1
fi

until ldapsearch -x -b dc=example,dc=org -D cn=admin,dc=example,dc=org -w admin | grep "dn: dc=example,dc=org"
do
    echo "OpenLDAP is not ready yet - sleeping 2s"
    sleep 2
done

ansible-playbook test.yml -e "ansible_python_interpreter=$(which python3)"

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

docker stop openldap && docker rm openldap
exit 0