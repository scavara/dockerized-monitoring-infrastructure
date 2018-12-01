p8s-file_sd_config-file:
  runner.state.orchestrate:
      - mods: p8s.generate-p8s-file_sd_config
  local.state.apply:
    - tgt: 'p8s-slave01.YOUR_DOMAIN'
    - arg:
      - p8s.generate-p8s-file_sd_config
