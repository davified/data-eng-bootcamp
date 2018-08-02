# Troubleshooting FAQ

### Insufficient disk space
Try running:
- `brew cleanup` (Remove any older formula versions from the Homebrew cellar)
- `docker system prune` (Remove dangling docker images)
- [if you're looking for something more drastic] `docker system prune -a` (Remove all docker images)

### Spark Labs

#### Cannot run any command on `spark` or `sc` object because of some error with `org.apache.hadoop.hive.ql.metadata.SessionHiveMetaStoreClient`
Solution:
- `rm metastore_db/*.lck` 
- `rm notebooks/metastore_db/*.lck`

