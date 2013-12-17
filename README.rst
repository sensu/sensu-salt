Sensu-Salt
##########

For details checkout my blog post: http://russell.ballestrini.net/sensu-salt/

Look at the ``top.sls`` to view what will be installed on each target.

Currently these states have only been tested on ``Ubuntu 12.04.3 LTS``.  

Warning:
 You must customize (and harden) settings in various state formulas.

TODO:
 Alter rabbitmq and sensu.client to support certs and SSL

TODO:
 Research if using pillar + jinja is worth while, 
 for example the following settings:

 .. code-block:: yaml

    sensu:

      rabbitmq:

        host: FQDN-or-IP
        port: 5672
        user: sensu
        password: mypass
        vhost: /sensu

     # {{ grains['fqdn'] }}
     # come up with elegant pillar subscription strat
     subscriptions:

       hostname1.example.com:
         - web

       hostname2.example.com:
         - db

