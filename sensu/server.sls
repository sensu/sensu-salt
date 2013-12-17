# include all common sensu configuration
include:
  - sensu.common

# Manage RabbitMQ Sensu vhost
sensu-rabbitmq-vhost:
  cmd.run:
    - name: rabbitmqctl add_vhost /sensu
    - unless: rabbitmqctl list_vhosts | grep -q /sensu
    - require:
      - service: rabbitmq-server 

# Manage RabbitMQ Sensu user
sensu-rabbitmq-user:
  cmd.run:
    - name: rabbitmqctl add_user sensu mypass
    - unless: rabbitmqctl list_users | grep -q sensu
    - require:
      - service: rabbitmq-server 

# Manage RabbitMQ Sensu permissions
sensu-rabbitmq-permissions:
  cmd.run:
    - name: rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
    - unless: rabbitmqctl list_user_permissions -p /sensu sensu | grep /sensu | grep -q '\.\*'
    - require:
      - cmd: sensu-rabbitmq-vhost
      - cmd: sensu-rabbitmq-user

# Example rabbitmqctl output:
#  rabbitmqctl add_vhost /sensu
#  rabbitmqctl add_user sensu mypass
#  rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

# Manage Sensu server configuration file
sensu-server-config:
  file.managed:
    - name: /etc/sensu/config.json
    - source: salt://sensu/server-config.json
    - require:
      - pkg: sensu-package

# Manage sensu-server (monitoring service)
sensu-server:
  service.running:
    - require:
      - service: redis-server 
    - watch:
      - file: sensu-server-config
      - file: sensu-checks-all-json

# Manage sensu-api (API service)
sensu-api:
  service.running:
    - require:
      - service: sensu-server
    - watch:
      - file: sensu-server-config

# Manage sensu-dashboard (Web service)
sensu-dashboard:
  service.running:
    - require:
      - service: sensu-server
    - watch:
      - file: sensu-server-config

