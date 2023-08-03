## Feature

This tool supports backup the following files or directories.

- `db.sqlite3` (for SQLite database)
- `config.json`
- `rsa_key*` (multiple files)
- `attachments` (directory)
- `sends` (directory)

Package all of the files into a tar file with a password protection.

## Usage
### 1. Manual Backup

```shell
docker run --rm \
  -v /path/to/bitwarden:/vaultwarden/data \
  -v /path/to/backup:/vaultwarden/backup \
  adoom2018/vaultwarden-tools:latest \
  -t backup -p backup-passwd
```

You need to explicitly specify the **data folder of Bitwarden** by replacing `/path/to/bitwarden` and the **backup folder** by replacing `/path/to/backup` with your own paths.

#### Options

- **-t/--type:** Use this command when you need to manual backup Bitwarden data once, specify **"backup"**
- **-p/--password:** Specify the password for the backup package.

### 2. Auto Backup

```shell
docker run --rm -d --name vaultwarden-tools \
  -v /path/to/bitwarden:/vaultwarden/data \
  -v /path/to/backup:/vaultwarden/backup \
  adoom2018/vaultwarden-tools:latest \
  -t auto -p backup-passwd -c "5 1 * * *" -k 10
```

You need to explicitly specify the **data folder of Bitwarden** by replacing `/path/to/bitwarden` and the **backup folder** by replacing `/path/to/backup` with your own paths.

#### Options

- **-t/--type:** Use this command when you need to auto backup Bitwarden data, specify **"auto"**
- **-p/--password:** Specify the password for the backup package.
- **-c/--cron:** Specify the cron for automatic backup, by default, backup is scheduled to run every day at 01:05 AM.
- **-k/--keep:** Specify the number of latest files to keep, by default, will keep latest 30 files.

### 3. Restore
> **Important:** 
> Restore will overwrite the existing files.
> You need to stop the bitwarden container before restore.
```shell
docker run --rm \
  -v /path/to/bitwarden:/vaultwarden/data \ 
  -v /path/to/backup:/vaultwarden/backup \
  adoom2018/vaultwarden-tools:latest \
  -t restore -f backup-package-name.tar.gz -p backup-passwd
```

You need to explicitly specify the **data folder of Bitwarden** by replacing `/path/to/bitwarden` and the **backup folder** by replacing `/path/to/backup` with your own paths.

#### Options

- **-t/--type:** Use this command when you need to backup Bitwarden data, specify **"restore"**
- **-f/--filename:** Specify the filename of the backup package you want to restore.
- **-p/--password:** Specify the password for the backup package.
