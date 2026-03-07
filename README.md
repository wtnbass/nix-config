# nix-config

## Troubleshooting

### `Too many open files` でビルドが失敗する

nix-daemon のファイルディスクリプタが枯渇しているため。デーモンを再起動する：

```bash
sudo launchctl stop systems.determinate.nix-daemon && sudo launchctl start systems.determinate.nix-daemon
```
