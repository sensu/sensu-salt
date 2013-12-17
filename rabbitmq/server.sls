rabbitmq-server:

  # install package
  pkg.installed:
    - name: rabbitmq-server

  # install configuration file
  # RabbitMQ config def: http://www.rabbitmq.com/configure.html
  file.managed:
    - name: /etc/rabbitmq/rabbitmq.config
    - contents: |
        [
            {rabbit, [
            {ssl_listeners, [5671]}
          ]}
        ].

    - require:
      - pkg: rabbitmq-server   

  # ensure service is running and restart service on pkg or conf changes
  service.running:
    - watch:
      - pkg: rabbitmq-server   
      - file: rabbitmq-server   

