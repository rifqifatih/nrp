FROM hbpneurorobotics/nrp:dev

RUN echo "127.0.0.1 $(uname -n)" | sudo tee --append /etc/hosts
RUN sudo git clone --progress --branch=master18 https://bitbucket.org/hbpneurorobotics/Models.git Models/
RUN sudo git clone --progress --branch=master18 https://bitbucket.org/hbpneurorobotics/Experiments.git Experiments/
RUN sudo chown -R bbpnrsoa:bbp-ext /home/bbpnrsoa/nrp/src/Experiments && sudo chown -R bbpnrsoa:bbp-ext /home/bbpnrsoa/nrp/src/Models
RUN /home/bbpnrsoa/nrp/src/user-scripts/rendering_mode cpu
RUN pip install pillow && python /home/bbpnrsoa/nrp/src/user-scripts/generatelowrespbr.py
RUN export NRP_MODELS_DIRECTORY=$HBP/Models && /home/bbpnrsoa/nrp/src/Models/create-symlinks.sh
RUN /bin/sed -e 's/localhost:9000/nrp-frontend.default.svc.cluster.local:9000/' -i /home/bbpnrsoa/nrp/src/ExDBackend/hbp_nrp_commons/hbp_nrp_commons/workspace/Settings.py
RUN /bin/sed -e 's/localhost:9000/nrp-frontend.default.svc.cluster.local:9000/' -i /home/bbpnrsoa/nrp/src/VirtualCoach/hbp_nrp_virtual_coach/hbp_nrp_virtual_coach/config.json
RUN cd $HOME/nrp/src && . $HOME/.opt/platform_venv/bin/activate && pyxbgen -u Experiments/bibi_configuration.xsd -m bibi_api_gen && pyxbgen -u Experiments/ExDConfFile.xsd -m exp_conf_api_gen && pyxbgen -u Models/environment_model_configuration.xsd -m environment_conf_api_gen && pyxbgen -u Models/robot_model_configuration.xsd -m robot_conf_api_gen && deactivate
RUN gen_file_path=$HBP/ExDBackend/hbp_nrp_commons/hbp_nrp_commons/generated && filepaths=$HOME/nrp/src && sudo cp $filepaths/bibi_api_gen.py $gen_file_path &&  sudo cp $filepaths/exp_conf_api_gen.py $gen_file_path && sudo cp $filepaths/_sc.py $gen_file_path && sudo cp $filepaths/robot_conf_api_gen.py $gen_file_path && sudo cp $filepaths/environment_conf_api_gen.py $gen_file_path
RUN /bin/sed -e 's/export ROS_IP=%(ENV_ROS_IP)s && //' -i /etc/supervisord.d/ros-simulation-factory_app.ini

USER root

CMD ["/usr/bin/supervisord", "-n"]

EXPOSE 8080
