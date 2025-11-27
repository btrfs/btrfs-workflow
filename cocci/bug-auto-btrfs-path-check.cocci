/*
 * Find instances with auto-cleaned btrfs_path and explicit cleanup (in any
 * call graph path).
 */
@@
expression E;
@@

* BTRFS_PATH_AUTO_FREE(E);
  <+...
* btrfs_free_path(E)
  ...+>
