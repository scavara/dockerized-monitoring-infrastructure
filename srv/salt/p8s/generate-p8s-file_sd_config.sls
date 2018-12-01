/mnt/targets/targets.json:
  salt.runner:
    - name: p8s-file_sd_config

  file.managed:
    - name: /mnt/targets/targets.json
    - source: salt://p8s/files/targets.json
    - mode: 644
    - user: nobody
    - group: nogroup
    - source_hash: salt://p8s/files/targets.sha1
    - keep_source: False
