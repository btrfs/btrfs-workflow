# Btrfs kernel patch submission

This document lays out the basic workflow for submitting kernel patches to the
linux-btrfs@vger.kernel.org mailinglist.  We're still beholden to email for
patch submission and review, but these tools will help us track the patch review
status so we can be more effective with our review time.

Mailinglist: linux-btrfs@vger.kernel.org

## Git commit messages

Follow the standard kernel commit message guidelines.  In addition, please keep
the following in mind.

- If you are fixing a regression from a specific commit, it's nice to add the
  Fixes: tag.  You can accomplish this using the "fixes" alias found in
  config/gitconfig, using `git fixes <bad commit>` to get the correct format for
  your Fixes: tag.
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
scripts, simply copy the contents of configs/gitconfig into your ~/.gitconfig so
you get properly formatted emails for submitting.

Please run `btrfs-setup-git-hooks <git dir>` to add the appropriate git hooks to
your tree.  This will help reduce the workload on the maintainers and reviewers
of your code by ensuring that patches are in the proper format and that commit
messages are spelled correctly.

## The btrfs helper scripts

These will send the emails as appropriate.  Copy these somewhere and chmod u+x,
or simply add the scripts/ directory to your `$PATH`.

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

1. Check the project page for anything in the 'Review wanted' queue, pick a series
   to review.

2. Review the patches.

3. Send your reply to the mailinglist.

4. If there are enough reviews, add the patches to branch **for-next**
