# coccinelle scripts

The directory cocci/ contains semantic scripts, specific to btrfs code base.
Scripts with prefix `bug-` are checking for bugs patterns, `opt-` are optional,
either cleanups or unification hints. Any output is supposed to be manually
reviewed and the scripts do not produce a perfect diff.

How to use it:

    $ cd path/to/sources
    $ spatch -sp_file $WORKFLOW_DIR/cocci/script.cocci -dir . -include_headers

This will run the `script.cocci` looking for patterns in the current directory
and recursively in subdirectories. If there's something found a diff is
printed.
