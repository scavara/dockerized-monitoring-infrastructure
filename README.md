# Dockerized monitoring infrastructure 
Go trough configs and adjust whereever you see CAPITALISED settings/values.
```
├── configs
│   ├── alerting-rules.d
│   │   └── first.rules
│   ├── prometheus.yml
│   └── recording-rules.d
│       └── first.rules
├── docker-compose.yml
├── externals
│   ├── root
│   │   └── start.sh
│   └── usr
│       └── local
│           └── sbin
│               ├── amtool
│               ├── crate_adapter
│               └── promtool
└── README.md
```
