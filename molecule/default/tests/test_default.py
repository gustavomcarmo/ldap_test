import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_people_exists(host):
    cmd = host.run("ldapsearch -x -b ou=people,dc=example,dc=org "
                   "-D cn=admin,dc=example,dc=org -w admin | "
                   "grep -c 'dn: ou=people,dc=example,dc=org'")
    assert cmd.rc == 0
    assert cmd.stdout == '1'


def test_groups_exists(host):
    cmd = host.run("ldapsearch -x -b ou=groups,dc=example,dc=org "
                   "-D cn=admin,dc=example,dc=org -w admin | "
                   "grep -c 'dn: ou=groups,dc=example,dc=org'")
    assert cmd.rc == 0
    assert cmd.stdout == '1'


def test_user_exists(host):
    cmd = host.run("ldapsearch -x -b ou=people,dc=example,dc=org "
                   "-D cn=admin,dc=example,dc=org -w admin | "
                   "grep -c 'dn: uid=jacksp,ou=people,dc=example,dc=org'")
    assert cmd.rc == 0
    assert cmd.stdout == '1'


def test_attr_exists(host):
    cmd = host.run("ldapsearch -x -b uid=jacksp,ou=people,dc=example,dc=org "
                   "-D cn=admin,dc=example,dc=org -w admin | "
                   "grep -c 'userPassword:: YmxhY2tfcGVhcmw='")
    assert cmd.rc == 0
    assert cmd.stdout == '1'
