# include all common sensu configuration
include:
  - sensu.common

# manage client.json file
sensu-client-json:
  file.managed:
    - name: /etc/sensu/conf.d/client.json
    - source: salt://sensu/client-config.json
    - template: jinja

# client service
sensu-client:
  service.running:
    - name: sensu-client
    - require:
      - pkg: sensu-package
    - watch:
      - file: sensu-client-json
      - file: sensu-checks-all-json

