# fstests

Staging repository: [git://github.com/btrfs/fstests](https://github.com/btrfs/fstests)



The branch **staging** contains all the tests that have fixes in **misc-next**.
This branch is supposed to be used by several people and should allow to run
the whole test suite without crashing the machine or adding noise to the test
results.

The branch will be rebased once tests are merged upstream or if a new patch
version is submitted and needs to be replaced. Use `git pull --rebase` to
update.

You can open an [issue](https://github.com/btrfs/fstests/issues) when a new
patch is submitted, so the group can see what's pending.

## Submit fstests with fixes

The whole idea is to have tests available at the time a fix is submitted and we
don't have to wait for the review and merge round. Minor issues are acceptable
as long as the test is functional.

Patches that are ready for review and merge should be sent to
[fstests@vger.kernel.org](https://lore.kernel.org/fstests/). If the
corresponding issue is created we can see which tests are ready, but otherwise
the tests can be picked from there for those interested in testing the fixes.

Alternatively, if the test is a in development and not yet suitable for
upstream review, you can open a [pull
request](https://github.com/btrfs/fstests/pulls) in the
[btrfs/fstests](https://github.com/btrfs/fstests) repository.  Use the
[*staging*](https://github.com/btrfs/fstests/tree/staging) branch as base.

## New test numbers

To avoid clashes in test numbers, pick a random one that's not used, please.
The final test number is determined at upstream merge time. The pending test
number should remain unchanged so we can use it for reference in bug reports.

Conflicting test numbers can be resolved by saving the patch as a file and then
changing the number string inside the patch file. The remainig trivial conflict
will be in the 'groups' file.

# Bug reports

Test failures should be reported in [fstests' repository
issues](https://github.com/btrfs/fstests/issues). Paste the important bits of
the test failure.  If you think it's relevant, paste other parts from the test
results, stack traces, source code pointers, test environment specifics (VM,
physical machine, storage type, memory size), mount options, mkfs options,
kernel config options.

Labels for reports:

* [patch](https://github.com/btrfs/fstests/issues?q=is%3Aissue+is%3Aopen+label%3Apatch) -- the reported issue has a patch, link is in the issue comment
* [patch?](https://github.com/btrfs/fstests/issues?q=is%3Aissue+is%3Aopen+label%3Apatch%3F) -- there's a patch that maybe fixes the issue but needs verification
* [fixed](https://github.com/btrfs/fstests/issues?q=is%3Aissue+is%3Aopen+label%3Afixed) -- the issue is fixed in misc-next

Issue subject: **test number** **type of report** additional information

Examples:

* test failure: **btrfs/123 ERROR: during balancing -EIO**
* lockdep: **generic/321 lockdep lockdep lock1 -> lock2 -> lock3**
* syzbot report: **syzbot WARNING in function_name**

The subject should capture the key information, like the reporting source, type
of failure and code area. Paste the lines from logs you usually look for (but
perhaps trim the irrelevant texts).

## Formatting tips

It's good to have the initial commit completely visible, without line wraps. Use:

    additional description

    ```
    text
    ```

For a foldable chunk of text you can use this template (keep the empty lines):

    <details>
    <summary>summary</summary>

    Write new text here and keep the lines above and below empty

    </details>

## Updating the staging branch

There's a dedicated volunteer updating the branch but you're free to add patch
the patches as well, as long as it meets the criteria.
