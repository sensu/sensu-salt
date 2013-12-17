base:

  # git needed to download sensu community plugins
  '*':
    - git

  # target glob to install sensu-client
  'sensu-client*':
    - sensu.client

  # target glob to install sensu-server, sensu-api,
  # sensu-dashboard, rabbitmq-server, redis-server
  'sensu-server*':
    - rabbitmq.server
    - redis.server
    - sensu.server
    - sensu.client

