# fstests

Staging repository: [git://github.com/btrfs/fstests](https://github.com/btrfs/fstests)

The branch **staging** contains all the tests that have fixes in **for-next**.
This branch is supposed to be used by several people and should allow to run
the whole test suite without crashing the machine or adding noise to the test
results.

The branch will be rebased once tests are merged upstream or if a new patch
version is submitted and needs to be replaced. Use `git pull --rebase` to
update.

## Submit fstests with fixes

The whole idea is to have tests available at the time a fix is submitted and we
don't have to wait for the review and merge round. Minor issues are acceptable
as long as the test is functional.

Patches that are ready for review and merge should be sent to
[fstests@vger.kernel.org](https://lore.kernel.org/fstests/).

## New test numbers

To avoid clashes in test numbers, pick a high (1000+) random one that's not
used, please.  The final test number is determined at upstream merge time. The
pending test number should remain unchanged so we can use it for reference in
bug reports.

Conflicting test numbers can be resolved by saving the patch as a file and then
changing the number string inside the patch file. The remainig trivial conflict
will be in the 'groups' file.

# Bug reports

Test failures should be reported in [btrfs/linux
issues](https://github.com/btrfs/linux/issues) (same as for patches).
Paste the important bits of the test failure.  If you think it's relevant,
paste other parts from the test results, stack traces, source code pointers,
test environment specifics (VM, physical machine, storage type, memory size),
mount options, mkfs options, kernel config options. Then add the issue to
project card, colum named 'Bugs'.

Use descriptive subject names of issues (add namely keywords), for example:

- BUG (test/123) 6.6
- REGRESSION 6.7 writing data
- CI (btrfs\_config) ...

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
