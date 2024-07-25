# fstests

Staging repository: [git://github.com/btrfs/fstests](https://github.com/btrfs/fstests)

The branch **staging** contains CI fixups and support and may contain test
cases before they merged upstream.  The branch is rebased on top of upstream
**for-next** version is submitted and needs to be replaced. Use `git pull --rebase` to update.

Patches should be sent upstream to [fstests@vger.kernel.org](https://lore.kernel.org/fstests/).

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
