# tree
Go trough configs and adjust wherever you see CAPITALISED settings/values.
```
├── bins
│   └── oauth2_proxy
├── configs
│   ├── alerting-rules.d
│   │   └── first.rules
│   ├── alertmanager.yml
│   ├── nginx
│   │   ├── certs.d
│   │   │   ├── YOUR_PROPER.crt
│   │   │   └── YOUR_PROPER.key
│   │   ├── nginx.conf
│   │   └── sites.d
│   │       └── p8s-master
│   ├── oauth2_proxy.cfg
│   ├── prometheus.yml
│   ├── recording-rules.d
│   │   └── first.rules
│   ├── registry-auth.yml
│   └── registry.yml
├── docker-compose.yml
└── externals
    ├── etc
    │   ├── crate_adapter
    │   │   └── config.yml
    │   ├── postfix
    │   │   └── main.cf
    │   └── systemd
    │       └── system
    │           └── crate_adapter.service
    ├── root
    │   └── start.sh
    └── usr
        └── local
            └── sbin
                ├── amtool
                ├── crate_adapter
                └── promtool
```
