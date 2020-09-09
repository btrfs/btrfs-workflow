# fstests

Staging repository: git://github.com/btrfs/fstests

The branch **staging** contains all the tests that have fixes in **misc-next**.
This branch is supposed to be used by several people and should allow to run
the whole test suite without crashing the machine.

The branch will be rebased once tests are merged upstream or if a new patch
version is submitted and needs to be replaced. Use `git pull --rebase` to
update.

You can open an issue when a new patch is submitted, so the group can see
what's pending.

## Submit fstests with fixes

The whole idea is to have tests available at the time a fix is submitted and we
don't have to wait for the review and merge round. Minor issues are acceptable
as long as the test is functional.

## New test numbers

To avoid clashes in test numbers, pick a random one that's not used, please.
The final test number is determined at upstream merge time. The pending test
number should remain unchanged so we can use it for reference in bug reports.

Conflicting test numbers can be resolved by saving the patch as a file and then
changing the number string inside the patch file. The remainig trivial conflict
will be in the 'groups' file.

# Bug reports

Test failures should be reported in this repository issues. Paste the important
bits of the test failure.  If you think it's relevant, paste other parts from
the test results, stack traces, source code pointers, test environment
specifics (VM, physical machine, storage type, memory size), mount options,
mkfs options, kernel config options.

Labels for reports:

* patch -- the reported issue has a patch, link is in the issue comment
* fixed -- the issue is fixed in misc-next

Issue subject: **test number** **type of report** additional information

For example a lockdep report could be: **btrfs/123 lockdep lock1 -> lock2 -> lock3**

## Updating the staging branch

There's a dedicated volunteer updating the branch but you're free to add patch
the patches as well, as long as it meets the criteria.
