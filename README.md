# tree
Go trough configs and adjust whereever you see CAPITALISED settings/values.
"
├── etc
│   └── salt
│       ├── master.d
│       │   └── reactor.conf
│       ├── minion.d
│       │   └── beacons.conf
│       └── pki
│           └── master
│               └── minions
│                   └── exclude_me
├── README.md
└── srv
    ├── reactor
    │   └── p8s-file_sd_config.sls
    └── salt
        ├── p8s
        │   ├── config.sls
        │   ├── files
        │   │   ├── p8s-telegraf.logrotate.jinja
        │   │   ├── targets.json
        │   │   ├── targets.sha1
        │   │   └── telegraf
        │   │       ├── etc
        │   │       │   └── telegraf
        │   │       │       └── telegraf.conf.jinja
        │   │       ├── scripts
        │   │       │   ├── init.sh
        │   │       │   ├── telegraf
        │   │       │   └── telegraf.service
        │   │       └── usr
        │   │           └── bin
        │   │               └── telegraf
        │   ├── generate-p8s-file_sd_config.sls
        │   ├── init.sls
        │   └── logging.sls
        └── _runners
            ├── p8s-file_sd_config.py
            └── p8s-file_sd_config.pyc
"
