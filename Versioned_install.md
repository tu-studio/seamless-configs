# Info on symlink structure for versioned install flag

```path
/usr/local/etc/
├── audio-matrix -> /usr/local/etc/audio-matrix-<location>-<node>-<version>/
├── audio-matrix-<location>-<node>-<version>
├── jack -> /usr/local/etc/jack-<location>-<node>-<version>/
├── jack-<location>-<node>-<version>
├── osc-kreuz -> /usr/local/etc/osc-kreuz-<location>-<node>-<version>/
├── osc-kreuz-<location>-<node>-<version>
├── wonder -> /usr/local/etc/wonder-<location>-<node>-<version>/
└── wonder-<location>-<node>-<version>
```

The systemd service files are not versioned.
