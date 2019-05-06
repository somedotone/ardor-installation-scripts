#!/bin/bash

###################################################################################################
# CONFIGURATION
###################################################################################################

SERVER_DOMAIN="<domain of ubuntu server>"

SUDO_USER_NAME="<name of to be created sudo user>"
SUDO_USER_PWD="<password of to be created sudo user>"

KNOWN_HOSTS_FILE_PATH="/home/<your user name>/.ssh/known_hosts"
IS_MAC=true


###################################################################################################
# DEFINES
###################################################################################################

CREATE_SUDO_USER_SCRIPT_NAME="create-sudo-user.sh"

INSTALL_ARDOR_SCRIPT_NAME="install-ardor.sh"
INSTALL_ARDOR_SCRIPT_PATH=$(dirname `which $0`)


###################################################################################################
# MAIN
###################################################################################################

if [ ${IS_MAC} == true ]; then
    ssh-keygen -R ${SERVER_DOMAIN}
else
    ssh-keygen -f ${KNOWN_HOSTS_FILE_PATH} -R ${SERVER_DOMAIN}
fi

scp ./${CREATE_SUDO_USER_SCRIPT_NAME} root@${SERVER_DOMAIN}: | tee log.txt
ssh -t root@${SERVER_DOMAIN} "chmod 700 ${CREATE_SUDO_USER_SCRIPT_NAME} && ./${CREATE_SUDO_USER_SCRIPT_NAME} -u ${SUDO_USER_NAME} -p ${SUDO_USER_PWD}" | tee -a log.txt

scp ${INSTALL_ARDOR_SCRIPT_PATH}/${INSTALL_ARDOR_SCRIPT_NAME} ${SUDO_USER_NAME}@${SERVER_DOMAIN}: | tee -a log.txt
ssh -t ${SUDO_USER_NAME}@${SERVER_DOMAIN} "chmod 700 ${INSTALL_ARDOR_SCRIPT_NAME} && ./${INSTALL_ARDOR_SCRIPT_NAME}" | tee -a log.txt