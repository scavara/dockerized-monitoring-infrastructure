telegraf:
  group:
    - present
  user:
    - present
    - shell: /bin/false
    - home: /dev/null
    - createhome: False
    - uid: 2000
    - gid_from_name: true
    - groups:
      - telegraf
    - optional_groups:
      - varnish

/etc/telegraf:
  file.directory:
    - name: /etc/telegraf
    - mode: 755
    - user: root
    - group: root

/etc/telegraf/telegraf.d:
  file.recurse:
    - source: salt://p8s/files/telegraf/etc/telegraf/telegraf.d
    - dir_mode: 755
    - file_mode: 644
    - user: root
    - group: root
    - include_empty: true

/etc/telegraf/telegraf.conf:
   file.managed:
    - source: salt://p8s/files/telegraf/etc/telegraf/telegraf.conf.jinja
    - template: jinja
    - user: root
    - group: root

/usr/bin/telegraf:
  file.managed:
    - source: salt://p8s/files/telegraf/usr/bin/telegraf
    - user: root
    - group: root
    - mode: 755

/var/log/telegraf:
  file.directory:
    - user: root
    - group: telegraf
    - mode: 775
    - require:
      - group: telegraf

/var/log/telegraf/telegraf.log:
  file.managed:
    - user: telegraf
    - group: telegraf
    - mode: 644

{% if grains['os'] in ['CentOS', 'Ubuntu'] %}
/lib/systemd/system/telegraf.service:
  file.managed:
    - source: salt://p8s/files/telegraf/scripts/telegraf.service
    - watch_in:
      - cmd: setup_init 

setup_init:
  cmd.run:
    - name: systemctl daemon-reload && systemctl enable telegraf
    - require:
      - file: /lib/systemd/system/telegraf.service
    - unless: service telegraf status 

{% elif grains['os'] == 'Gentoo' %}
/etc/init.d/telegraf:
  file.managed:
    - source: salt://p8s/files/telegraf/scripts/telegraf
    - user: root
    - group: root
    - mode: 755
    - watch_in:
      - cmd: setup_init 

setup_init:
  cmd.run:
    - name: rc-config add /etc/init.d/telegraf
    - require:
      - file: /etc/init.d/telegraf
    - unless: rc-config show | grep telegraf 
{% endif %}

telegraf.service:
  service.running:
   - name: telegraf
   - enable: true
   - restart: true
   - watch:
     - file: /etc/telegraf/telegraf.conf

