# ardor-installation-scripts

Repository for [Ardor](https://ardorplatform.org) node installation scripts. It contains the following three scripts:

### install-ardor.sh

This is the *main* script. It installs, creates and configures all necessary parts to run an Ardor node (mostly) autonome on an Ubuntu based server. There is a Configuration section at the top of the script to configure the node regarding your needs. You can install an Ardor mainnet node, testnet node or both on one server. If you want to install both, make sure that the server is accessible via two seperate domains.

It also installs an *update-nodes.sh* script on the server, which can be used to easily update the nodes in case of a new Ardor release. You only need to run it. It downloads, stops, updates and restarts the node by itself.

To install (an) Ardor node(s), copy the script to the Ubuntu server and execute it. It is designed to run with a sudo user.

If you don't have a sudo user on the server yet (for example if just created a brand new Ubuntu Droplet from Digital Ocean), you can use the *create-sudo-user.sh* script to automatically create one.


### create-sudo-user.sh

This script let's you create a sudo user with ease. Just configure it properly at the Configuration section and execute it as a root user. You can also call it with parameters. Call it with ``./create-sudo-user.sh -h`` for parameter description.

You can combine the sudo user creation and node installation with the *remote-install.sh* script.


### remote-install.sh

This script let's you first create an sudo user and then install the Ardor nodes on an Ubuntu server completely remotely. You just need to configure it in the Configuration section and also configure the *install-ardor.sh* script. It then automatically logs in as root on the remote server (ssh pubkey of local machine must be known to the remote server), creates the configured sudo user, copies the *install-ardor.sh* script to the server (logged in as sudo user) and executes it. *The remote-install.sh* script is only tested on Ubuntu and MacOS machines.
