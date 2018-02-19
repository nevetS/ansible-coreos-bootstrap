# coreos-bootstrap

In order to effectively run ansible, the target machine needs to have a python
interpreter. Coreos machines are minimal and do not ship with any version of
python. To get around this limitation we can use the toolbox container, which
by default is the latest Fedora and contains the python3.6 interpreter.  The
coreos-bootstrap role will install a shell script that calls the toolbox python
interpreter, and install the httplib2 python module so that the get_url module
will work properly.

Originally forked from
https://github.com/defunctzombie/ansible-coreos-bootstrap, but that repository
is inactive, and pypy generates errors because it was compiled with different
shared libraries than come installed on coreos (like libssl).

# install

Unfortunately, I don't know enough about galaxy yet, so clone this role into
your project:

  cd your_ansible_project
  git clone https://github.com/nevetS/ansible-coreos-bootstrap bootstrap
  
or add it as a submodule

  cd your_ansible_project
  git submodule add https://github.com/nevetS/ansible-coreos-bootstrap bootstrap
  
# Configure your project

Unlike a typical role, you need to configure Ansible to use an alternative
python interpreter for coreos hosts. This can be done by adding a `coreos`
group to your inventory file and setting the group's vars to use the new python
interpreter. This way, you can use ansible to manage CoreOS and non-CoreOS
hosts. Simply put every host that has CoreOS into the `coreos` inventory group
and it will automatically use the specified python interpreter. 
```
[coreos]
host-01
host-02

[coreos:vars]
ansible_ssh_user=core
ansible_python_interpreter=/home/core/bin/python
```

This will configure ansible to use the python interpreter at
`/home/core/bin/python` which will be created by the bootstrap role. 

## Bootstrap Playbook

Now you can simply add the following to your playbook file and include it in
your `site.yml` so that it runs on all hosts in the coreos group. 

```yaml
- hosts: coreos
  gather_facts: False
  roles:
    - bootstrap
```

Make sure that `gather_facts` is set to false, otherwise ansible will try to
first gather system facts using python which is not yet installed! 

# License
MIT
