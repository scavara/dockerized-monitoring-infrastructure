/etc/logrotate.d/telegraf:
  file.managed:
    - source: salt://p8s/files/p8s-telegraf.logrotate.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0440
