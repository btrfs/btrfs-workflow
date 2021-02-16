# Using fstests

This is a document to describe how to actually use fstests effectively.
Documentation on how the btrfs team handles results and fixes can be found
[here](https://github.com/btrfs/btrfs-workflow/fstests.md).

## Checkout the code

First checkout the [official fstests
repo](git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git).  From there we
recomend running

```
git remote-add btrfs https://github.com/btrfs/fstests.git
```

in order to access our staging tree, but this part isn't strictly necessary.

## Prerequesites

You need to have the following

1. A disk you can format.  If you use our script you need at least 100G sized
   disk, but you can configure things manually if you wish.
2. `./configure && make` in fstests.

## Glossary

- **scratch device**. This is the device that you can/will mkfs every single
  time a test runs.  This doesn't happen with every test, but it can, it is fair
  game to be completely blown away.
- **test device**. This is the "main" device, it is not mkfs'ed by any of the
  tests, it is just mounted and unmounted between tests.
- **scratch pool**.  This is just a list of scratch devices, for btrfs tests
  that test RAID or device add or removal, we need to be able to format a bunch
  of disks to do the test, we use a pool to accomplish this.

## Configure fstests

You need at least 2 disks for fstests to be useful, but for btrfs you really
need enough to run all of the RAID profiles with device replace, which as of
this writing is a minimum of 6 disks.  Generally we accomplish this with LVM,
you can use the `setup-lvm-fstests.sh` script found in the scripts/ directory in
this repo, and it will carve up a single device into LV's and write the
appropriate `local.config` to your fstests directory.  You run it like this

```
setup-lvm-fstests.sh xfstests/ /dev/nvme0n1
```

which creates 10 10g LV's for your scratch pool and associated disks.  This
means you need to have a minimum of 100g disk in order to use this script, if
you don't have that you can simply adjust the size of the disks or number as
needed.

IF YOU DON'T USE THE CONFIG SCRIPT, do the following

1. `mkdir /mnt/test && mkdir /mnt/scratch`.
2. `mkfs.btrfs -f <your scratch dev>`.
3. Edit your local.config in your fstests directory to match something like the
   one generated for you by `setup-lvm-fstests.sh`.

You can add more specific testing outside of the defaults, for example many of
us use sections in order to run different mount options with the same machine.
So you can adjust your configuration to look something like the following

```
[normal]
TEST_DIR=/mnt/test
TEST_DEV=/dev/mapper/vg0-lv0
SCRATCH_MNT=/mnt/scratch
SCRATCH_DEV_POOL="/dev/whatever"

[compression]
MOUNT_OPTIONS="-o compress"
```

## Run fstests

Running fstests is relatively simple, generally you're going to start with

```
./check -g auto
```

to run all of the tests in the `auto` group.  A subset of tests always fail, we
are doing our best to cull things that make no sense or fail all of the time,
but sometimes things are missed.  The usual workflow is

```
# Write patch, boot into kernel without your patch
./check -g auto

# Save the list of tests that failed, apply your patch and boot into the new
# kernel
./check -g auto
```

Then validate that you didn't regress any new tests.  You can skip the first
step if you wish and check the results of our nightly builds which can be found
[here](http://toxicpanda.com).  These are a variety of mount and mkfs options
run against our staging branch every night, so is a good list of what is
currently failing.

You can also run specific tests.  For example, if you regress `btrfs/011` you
can simply run

```
./check btrfs/011
```

to iterate on your work instead of running the whole suite.  If you are
relatively confident in your patch and you want to just do a quick smoke test
then you can run

```
./check -g quick
```

instead.  However this should be reserved for more experienced developers, you
don't get yelled at if your patch showed up a few hours later because you ran
the full suite of tests.

## Writing a new fstest

fstests has a helper script to template out a new test, you can simply run
`./new <type>` where `<type>` is either generic, btrfs, ext4, or xfs.  This will
choose a new fstest number and generate a template.  You can edit the test at
this point, or you can exit and let the script finish and then go back and edit
your new test.  The script will ask you which group, you should generally always
use `auto`, and if the test is short `quick`.  Other groups exist, and can be
added as necessary.

The way fstests works is by comparing a "golden output" with the output
generated when the test runs.  This will clearly depend on the test itself, so
after the test is done you need to run the test on your machine, and then copy
the results/<test type>/<test number>.out.bad to tests/<test type/<test
number>.out to set your golden output.  Here's a list of best practices

1. Write a description of the test in the comment block at the top.  If your
   test is a regression test for a specific fix, or a test for a new feature,
   add the patch names that the test relies on, even if they haven't been
   committed yet.  This helps us track where the fixes were later on.
2. Make sure your `_require` statements cover all of your tests requirements.
   For example, if you need to use a scratch device, make sure you use
   `_require_scratch`.  If you require a special xfs_io command, use
   `_require_xfs_io_command <command>`.
3. Make sure you use the command variables for your commands.  For example, do
   not do something like

   ```
   xfs_io -f -c "pwrite 0 1M" file
   ```

   instead use $XFS_IO_PROG, like so

   ```
   $XFS_IO_PROG -f -c "pwrite 0 1M" file
   ```
   
   If you need to know what the command variable name is, look at common/config
   in the fstests directory.  This has all of the commands with their names.  If
   you need a new one, make sure to add it to this file and submit a separate
   patch for it.
4. Don't redirect all output to /dev/null.  For things that change, like
   bytenr's or speeds, fstests has filters.  Again, using xfs_io as an example,
   you would do something like the following

   ```
   $XFS_IO_PROG -f -c "pwrite 0 1M" file | _filter_xfs_io
   ```

   There are a variety of command filters, you can find them in common/filter
   and common/filter.btrfs.  Sometimes it is OK to redirect to /dev/null, but
   generally we prefer to just spit out the output into our golden output.
5. Validate your test.  Run your test with and without your fix, make sure that
   it fails properly without your fix applied and it succeeds with your fix
   applied.  If you are adding a new feature, make sure it properly skips your
   test without your feature applied and that it works correctly when your
   feature is applied.
6. Look at other tests in the same directory.  Chances are somebody else did
   something related to what you are doing.  Look at those tests to get an idea
   of what is acceptable.  This will help a lot when getting reviews for your
   test.
