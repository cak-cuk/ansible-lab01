#!/bin/bash

. ${WORKSPACE}/scripts/common.sh
export
source /home/jenkins/.bashrc
export PATH=$HOME/.local/bin:$PATH
pip3 install --user --upgrade pip
pip3 install --user --upgrade -r requirements/pip3.txt
which ansible-galaxy
ansible-galaxy role remove udienz.bind
ansible-galaxy install -f -r requirements/galaxy.yaml
