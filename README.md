# Btrfs workflow

Btrfs workflow docs and supporting scripts.

* [fstests and related workflows](fstests.md).  Workflow for new tests, general
  documentation on how to setup, configure, and use fstests, as well as how to
  write new tests.
* [Coccinelle](cocci/) coccinelle scripts to look for known bug patterns,
  suggested cleanups, etc
* [Scripts](scripts/) for integrating the github issues into our email submission workflow.

# Group development

The development model partially works as a group and partially as the traditional
maintainer model. Longterm developers are allowed to commit their changes or
take responsibility of other people patches. For the rest the fall back is the
maintainer.  The general guidelines for patch submission quality and style
still apply.

The repository for this is

[https://github.com/btrfs/linux](https://github.com/btrfs/linux)

We using one main branch `for-next`.

- the code has passed testing and does not crash easily (basically anything
  that would affect other devlopers' work negatively)
- the branch is updated frequently (new patches, updated patches, removed
  patches)
- use as base branch for current development, minor conflicts are expected
- patches with functional dependency need coordination

This branch is part of `linux-next` testing so build or crash reports get sent.

In addition to `for-next` the branch `misc-next` contains random patches from
mailinglist for early testing (also part of the `linux-next`). You may get
reports from testing even if you did not add the patch anywhere yourself.

## tl;dr developer workflow

1.   Write code off of your base
2.   Submit the pull request against the branch `ci` (against `btrfs/linux`)
2.1. Alternatively you can also merge the `ci` branch and then send the pull request
3.   Send your patches to linux-btrfs@vger.kernel.org.
4.   Test your changes, either on your testing setup ~~or on the github CI~~
5.   Once ~~the CI run is clean and~~ you have the required `Reviewed-by`'s,
     update your local `for-next` branch and append your patches. Then push the
     changes to the repository, in the best case with fast-forward update.
     Otherwise look for conflicting changes and resolve them.

## Who should review my patches?

Another member of the development team.  Outside developer `Reviewed-by`'s
should be appropriately included, but you must have a `Reviewed-by` from a
committing member in order to commit your own code.

For big features you must have at least 2 `Reviewed-by`'s from a committing
member in order to commit your code.  You **must** also have fstests that will test
your code in the CI that run when you test your code. Put that to the branch
*staging* in our `btrfs/fstests.git` repository (it's pulled before each CI run).

## What happens if I race with another developer?

Rebase onto the new source.  Generally the workflow is

1. `git fetch origin`
2. Find the first hash of your series, `git rebase <HASH>~1 --onto
   origin/<base>`.
3. Fixup any merge errors.
4. `git push` if there were no merge problems, re-run CI if you're worried there
   may have been bugs introduced.

## What happens if there are fixups found after the fact?

We will be force rebasing these branches, so we won't always be able to cleanly
do a fast forward `git push`.  For fixups utilize `git rebase -i` appropriately.

1. Identify the hash of the patch you wish to fixup.
2. Notify all the developers on slack that you're going to be force pushing.
3. `git rebase -i <HASH>~1`, find the line and change `pick` to `edit` for your
   hash.
4. Apply the fixup, run `git commit -a --amend`.
5. `git rebase --continue`, fixup any problems.
6. Optionally re-run CI on the branch by pushing to your own repo and creating a
   PR to trigger the ci run, with the ci branch applied.
6. `git push origin +<base>:<base>`
7. Verify you didn't break anything.
8. Let everybody know you're done force pushing.
9. Notification about `for-next` update is posted on the `btrfs-for-next` slack channel.

## What about outside contributors?

For outside contributors any one of the committing members may merge their
patches, but must have an additional `Reviewed-by` from another committing
member.  The committing member must still follow the same process to make sure
the code is properly tested and validated before merging.

## Misc

Do not rebase the base branch unless there's a reason for it. A good reason
is a merge conflict resolution that exists outside of `for-next`, e.g. during
merge window resolved by Linus.

Rebases of the `for-next` will happen on each Monday after a release of a `rc`
kernel. Patches merged meanwhile to `master` will disappear from `for-next` if
duplicated.

Another rebase could happen right after Linus merges the last pull request.

Note that changes to patches in the middle of the branch are two fold:

- code changes, `git rebase` will handle that, either cleanly or with a
  reported conflict

- changelog, this is **not handled** by git rebase and local patch may override
  the one in the base branch, thus losing any previous changes

Please be careful and check twice before pushing. In case you mess something up
it's still possible to revert to previous state. Make a local copy of any
relevant branch, read output of `git push` command and note commit ids,
use `git reflog` to see previous contents of the branches. This should
provide enough data points to resolve the conflicts and prevent losses.

## Build-only checks

Optionally you can let your branch get build-tested on x86\_64 with various
config option combinations. Submit a pull request against branch `build`. This
will run on the github hosted runners, more PRs can be sent in parallel.
The same checks can be also run locally, replicate the steps in `.github/workflows/build.yml`.

Automatic build check is set up for for pushing branch `for-next`.


# Kernel patch submission

This document lays out the basic workflow for submitting kernel patches to the
linux-btrfs@vger.kernel.org mailinglist.  We're still beholden to email for
patch submission and review, but these tools will help us track the patch review
status so we can be more effective with our review time.

Mailinglist: linux-btrfs@vger.kernel.org (archves https://lore.kernel.org/linux-btrfs/)

## Git commit messages

Follow the standard kernel commit message guidelines.  In addition, please keep
the following in mind.

- If you are fixing a regression from a specific commit, it's nice to add the
  `Fixes:` tag.  You can accomplish this using the "fixes" alias found in
  `config/gitconfig`, using `git fixes <bad commit>` to get the correct format for
  your `Fixes:` tag.
- For lockdep fixes, crash fixes, warnings, please include the lockdep message
  and stack trace in the commit
- If you get a spelling mistake flagged by the commit-msg hook that is not a
  mistake, please add it to scripts/btrfs-dict and then run `make` in that
  directory and commit the results so that we can all benefit from not having
  false positives for spelling.

## Prerequisites

### Github cli tools

The github cli tools, which can be found here

https://github.com/cli/cli/releases

NOTE: You must install this on a box that can open a web browser, because you
need to get the 0auth token.  This is fairly straightforward:

1. Install the gh package.
2. run `gh auth login`.  This will launch the browser to the 0auth stuff, follow
   the prompts.
3. [OPTIONAL] If you have a headless machine that you do development on, you
   will need to copy the 0auth token to this machine.  Copy
   ~/.config/gh/hosts.yml to the machine you will be using for development.

### Git config options

These should be set regardless of whether you are going to use the helper
scripts, simply copy the contents of `gitconfig` into your `~/.gitconfig` so
you get properly formatted emails for submitting.

Please run `btrfs-setup-git-hooks <git dir>` to add the appropriate git hooks to
your tree.  This will help reduce the workload on the maintainers and reviewers
of your code by ensuring that patches are in the proper format and that commit
messages are spelled correctly.

## The btrfs helper scripts

These will send the emails as appropriate.  Copy these somewhere and `chmod u+x`,
or simply add the `scripts/` directory to your `$PATH`.

## Developer workflow

1. `git format-patch` your patch series (please make sure your ~/.gitconfig is
   set properly so they get formatted correctly.)

   * For a patch series: `mkdir patches; git format-patch -o patches -#`
      * This generates a patches/0000-cover-letter.patch, please fill this in
        with the description of the series before sending.
   * For a single patch: `git format-patch -1`

2. `btrfs-send-patches <patches|0001-<whatever>.patch>`.  This will invoke
   `git send-email` for you

## Reviewer workflow

The project page or issues are not used for tracking patches anymore. Check the
mailinglist regularly, respond to patches that change you are familiar with.
Everybody is encouraged to try to review also code they're not familiar with.
Proofreading changelogs and comparing that to the code helps to spread the
knowledge and can also spark feedback and clarifications.

If there are enough reviews, add the patches to branch **for-next**.

It's also OK to review patches that have already landed in `for-next`, just be
careful in case you're adding your `Reviewed-by` tags not to overwrite other
changes.
