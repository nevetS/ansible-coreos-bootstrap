#!/bin/bash
# file bootstrap2.sh
# author: Steve Kallestad <kallestad@gmail.com>
# purpose: installs a shell script that will run a python enabled container
#          since python is not installed on coreos.
#
# parameters: proxy can be passed in as the first command line argument
#             i.e. bootstrap2.sh 192.168.1.1:3128


if [ $# -ne 0 ]; then
    #set proxy variables 
    echo "USING PROXY ${1}"
    http_proxy=${1} 
    https_proxy=${1}
    use_proxy=yes
fi


function setup_python(){
    #create a bin/python script and make it executable
    mkdir -p $HOME/bin
    cat > $HOME/bin/python <<EOF
#!/bin/bash
toolbox --bind=/home:/home python3 "\$@"
EOF
    chmod u+x $HOME/bin/python
    return
}

function install_httplib2(){
    #for using the get_url module
    toolbox pip3 install httplib2
}

setup_python
install_httplib2
cd
touch .ansible_bootstrapped
