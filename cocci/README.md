# coccinelle scripts

The directory cocci/ contains semantic scripts, specific to btrfs code base.
Any output is supposed to be manually reviewed and the scripts do not produce a
perfect diff.

How to use it from this repository (generates *.diff* with the results):

    $ ./run-one.sh /path/to/linux.git/fs/btrfs script.cocci
    $ ./run-all.sh /path/to/linux.git/fs/btrfs

Or in general:

    $ cd path/to/sources
    $ spatch -sp_file $WORKFLOW_DIR/cocci/script.cocci -dir . -include_headers

This will run the `script.cocci` looking for patterns in the current directory
and recursively in subdirectories. If there's something found a diff is
printed.

## Script types

The file name suggests the purpose of the script:

- *bug* - a pattern that is most likely a bug, eg. buggy behaviour or missing error handling 
- *match* - match a given pattern and usually needs further examination of the results
- *opt* - optional improvements or cleanups
- *style* - coding style suggestion or validation
