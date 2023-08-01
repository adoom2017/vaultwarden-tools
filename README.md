## Feature

This tool supports backup the following files or directories.

- `db.sqlite3` (for SQLite database)
- `config.json`
- `rsa_key*` (multiple files)
- `attachments` (directory)
- `sends` (directory)

Package all of the files into a tar file with a password protection.

## Usage
### 1. Backup

```shell
docker run --rm \
  -v /path/to/bitwarden:/vaultwarden/data \
  -v /path/to/backup:/vaultwarden/backup \
  adoom/vaultwarden-tools:v1.2 \
  -t backup -p backup-passwd
```

You need to explicitly specify the **data folder of Bitwarden** by replacing `/path/to/bitwarden` and the **backup folder** by replacing `/path/to/backup` with your own paths.

#### Options

- **-t/--type:** Use this command when you need to backup Bitwarden data, specify **"backup"**
- **-p/--password:** Specify the password for the backup package.

### 2. Restore
> **Important:** 
> Restore will overwrite the existing files.
> You need to stop the bitwarden container before restore.
```shell
docker run --rm \
  -v /path/to/bitwarden:/vaultwarden/data \ 
  -v /path/to/backup:/vaultwarden/backup \
  adoom/vaultwarden-tools:v1.2 \
  -t restore -f backup-package-name.tar.gz -p backup-passwd
```

You need to explicitly specify the **data folder of Bitwarden** by replacing `/path/to/bitwarden` and the **backup folder** by replacing `/path/to/backup` with your own paths.

#### Options

- **-t/--type:** Use this command when you need to backup Bitwarden data, specify **"restore"**
- **-f/--filename:** Specify the filename of the backup package you want to restore.
- **-p/--password:** Specify the password for the backup package.