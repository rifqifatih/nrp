#!/bin/bash

# Get public IP
export NODE_IP=$(curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

echo "127.0.0.1 $(uname -n)" | sudo tee --append /etc/hosts
sudo git clone --progress --branch=master18 https://bitbucket.org/hbpneurorobotics/Models.git Models/
sudo git clone --progress --branch=master18 https://bitbucket.org/hbpneurorobotics/Experiments.git Experiments/
sudo chown -R bbpnrsoa:bbp-ext /home/bbpnrsoa/nrp/src/Experiments && sudo chown -R bbpnrsoa:bbp-ext /home/bbpnrsoa/nrp/src/Models
/home/bbpnrsoa/nrp/src/user-scripts/rendering_mode cpu
pip install pillow && python /home/bbpnrsoa/nrp/src/user-scripts/generatelowrespbr.py
export NRP_MODELS_DIRECTORY=$HBP/Models && /home/bbpnrsoa/nrp/src/Models/create-symlinks.sh
cd $HOME/nrp/src && . $HOME/.opt/platform_venv/bin/activate && pyxbgen -u Experiments/bibi_configuration.xsd -m bibi_api_gen && pyxbgen -u Experiments/ExDConfFile.xsd -m exp_conf_api_gen && pyxbgen -u Models/environment_model_configuration.xsd -m environment_conf_api_gen && pyxbgen -u Models/robot_model_configuration.xsd -m robot_conf_api_gen && deactivate
gen_file_path=$HBP/ExDBackend/hbp_nrp_commons/hbp_nrp_commons/generated && filepaths=$HOME/nrp/src && sudo cp $filepaths/bibi_api_gen.py $gen_file_path &&  sudo cp $filepaths/exp_conf_api_gen.py $gen_file_path && sudo cp $filepaths/_sc.py $gen_file_path && sudo cp $filepaths/robot_conf_api_gen.py $gen_file_path && sudo cp $filepaths/environment_conf_api_gen.py $gen_file_path

# For kubernetes
/bin/sed -e 's/localhost:9000/'"$NODE_IP"':30000/' -i /home/bbpnrsoa/nrp/src/ExDBackend/hbp_nrp_commons/hbp_nrp_commons/workspace/Settings.py
/bin/sed -e 's/localhost:9000/'"$NODE_IP"':30000/' -i /home/bbpnrsoa/nrp/src/VirtualCoach/hbp_nrp_virtual_coach/hbp_nrp_virtual_coach/config.json

# For local docker
# /bin/sed -e 's/localhost:9000/host.docker.internal:9000/' -i /home/bbpnrsoa/nrp/src/ExDBackend/hbp_nrp_commons/hbp_nrp_commons/workspace/Settings.py
# /bin/sed -e 's/localhost:9000/host.docker.internal:9000/' -i /home/bbpnrsoa/nrp/src/VirtualCoach/hbp_nrp_virtual_coach/hbp_nrp_virtual_coach/config.json

sudo ROS_IP=$(hostname -I | cut -d " " -f 1) HBP=/home/bbpnrsoa/nrp/src /usr/bin/supervisord -n