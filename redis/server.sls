redis-server:
  
  # install package
  pkg.installed:
    - name: redis-server

  # ensure service is running
  service.running:
    - name: redis-server
