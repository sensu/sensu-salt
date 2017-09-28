# configure the sensu repo
sensu-pkgrepo:
  pkgrepo.managed:
    - humanname: Sensu
    - name: deb http://repos.sensuapp.org/apt sensu main
    - file: /etc/apt/sources.list.d/sensu.list
    - keyid: 7580C77F
    - keyserver: keyserver.ubuntu.com
    - key_url: https://repos.sensuapp.org/apt/pubkey.gpg
    - require_in:
      - pkg: sensu-package

# install the sensu-package
sensu-package:
  pkg.installed:
    - name: sensu

# tell plugins to use embeded ruby
sensu-embeded-ruby-true:
  file.replace:
  - name: /etc/default/sensu
  - pattern: EMBEDDED_RUBY=false
  - repl: EMBEDDED_RUBY=true

# checks that all hosts run
sensu-checks-all-json:
  file.managed:
    - name: /etc/sensu/conf.d/checks-all.json
    - source: salt://sensu/checks-all.json
    - template: jinja

# download public plugins and checks
sensu-git-public-plugins:
  git.latest:
    - name: https://github.com/sensu/sensu-community-plugins.git
    - target: /etc/sensu/community
    - require:
      - file: sensu-checks-all-json
      - pkg: git

# install public plugins and checks
sensu-symlink-public-plugins:
  file.symlink:
    - name: /etc/sensu/plugins
    - target: /etc/sensu/community/plugins
    - force: True
    - require:
      - git: sensu-git-public-plugins

