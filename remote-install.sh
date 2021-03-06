#!/bin/bash

###################################################################################################
# CONFIGURATION
###################################################################################################

SERVER_DOMAIN="<domain of ubuntu server>"

SUDO_USER_NAME="<name of to be created sudo user>"
SUDO_USER_PWD="<password of to be created sudo user>"

IS_MAC=true

# use with caution. If you want to revoke your decission later, you manually need to edit /etc/ssh/sshd_config
DISABLE_ROOT_LOGIN=false 
DISABLE_ROOT_PASSWORD_LOGIN=false


###################################################################################################
# DEFINES
###################################################################################################

KNOWN_HOSTS_FILE_PATH="/home/$(whoami)/.ssh/known_hosts"
CREATE_SUDO_USER_SCRIPT_NAME="create-sudo-user.sh"

INSTALL_ARDOR_SCRIPT_NAME="install-ardor.sh"
INSTALL_ARDOR_SCRIPT_PATH=$(dirname `which $0`)

CREATE_SUDO_USER_CMD="chmod 700 ${CREATE_SUDO_USER_SCRIPT_NAME} && ./${CREATE_SUDO_USER_SCRIPT_NAME} -u ${SUDO_USER_NAME} -p ${SUDO_USER_PWD}"
DISABLE_ROOT_LOGIN_CMD='sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config'
DISABLE_ROOT_PASSWORD_LOGIN_CMD='sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config'


###################################################################################################
# MAIN
###################################################################################################

if [ ${IS_MAC} == true ]; then
    ssh-keygen -R ${SERVER_DOMAIN}
else
    ssh-keygen -f ${KNOWN_HOSTS_FILE_PATH} -R ${SERVER_DOMAIN}
fi

SERVER_ACCESS_CMD=""
if [ ${DISABLE_ROOT_LOGIN} == true ]; then SERVER_ACCESS_CMD="${DISABLE_ROOT_LOGIN_CMD} && "; fi
if [ ${DISABLE_ROOT_PASSWORD_LOGIN} == true ]; then SERVER_ACCESS_CMD="${SERVER_ACCESS_CMD}${DISABLE_ROOT_PASSWORD_LOGIN_CMD} && "; fi
SERVER_ACCESS_CMD="${SERVER_ACCESS_CMD}${CREATE_SUDO_USER_CMD}"

scp ./${CREATE_SUDO_USER_SCRIPT_NAME} root@${SERVER_DOMAIN}: | tee log.txt
ssh -t root@${SERVER_DOMAIN} "${SERVER_ACCESS_CMD}" | tee -a log.txt

scp ${INSTALL_ARDOR_SCRIPT_PATH}/${INSTALL_ARDOR_SCRIPT_NAME} ${SUDO_USER_NAME}@${SERVER_DOMAIN}: | tee -a log.txt
ssh -t ${SUDO_USER_NAME}@${SERVER_DOMAIN} "chmod 700 ${INSTALL_ARDOR_SCRIPT_NAME} && ./${INSTALL_ARDOR_SCRIPT_NAME}" | tee -a log.txt