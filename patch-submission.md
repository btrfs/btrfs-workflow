# Btrfs kernel patch submission

This document lays out the basic workflow for submitting kernel patches to the
linux-btrfs@vger.kernel.org mailinglist.  We're still beholden to email for
patch submission and review, but these tools will help us track the patch review
status so we can be more effective with our review time.

Mailinglist: linux-btrfs@vger.kernel.org

Patch review queue: https://github.com/btrfs/linux/projects/1

## Prerequisites

### Github cli tools

The github cli tools, which can be found here

  https://github.com/cli/cli/releases

NOTE: You must install this on a box that can open a web browser, because you
need to get the 0auth token.  This is fairly straightforward

1. Install the gh package.
2. run `gh repo view`.  This will launch the browser to the 0auth stuff, follow
   the prompts.
3. [OPTIONAL] If you have a headless machine that you do development on, you
   willl need to copy the 0auth token to this machine.  Copy
   ~/.config/gh/hosts.yaml to the machine you will be using for development.

### Git config options

These should be set irregardless of wether you are going to use the helper
scripts, simply copy the contents of configs/gitconfig into your ~/.gitconfig so
you get properly formatted emails for submitting.

## The btrfs helper scripts

These will generate the github issues for you and send the emails as
appropriate.  Copy these somewhere and chmod u+x, or simply add the scripts/
directory to your `$PATH`.

## Developer workflow

1. `git format-patch` your patch series (please make sure your ~/.gitconfig is
   set properly so they get formatted correctly.)

   * For a patch series: `mkdir patches; git format-patch -o patches -#`
      * This generates a patches/0000-cover-letter.patch, please fill this in
        with the description of the series before sending.
   * For a single patch: `git format-patch -1`

2. `btrfs-send-patches <patches|0001-<whatever>.patch>`.  This will invoke
   `git send-email` for you, and will generate the github issues with the links
   for you.

3. If you receive feedback on a patch and the reviewer doesn't move your issue
   to the "Incoming queue, pending" stage of the project, please do that so
   people know you are working on those patches.

## Reviewer workflow

1. Check the project page for anything in the 'To Review' queue, pick a series
   to review.

2. Review the patches.

3. Mark them with your reviewed tag if you accept, mark with your comment tag if you have comments and move to the "Incoming queue, pending" stage of the project.

## Maintainer workflow

1. Tag with the appropriate target tag.  Some big patch series aren't destined
   for the next merge window, so tags are used so developers know when to expect
   their patches to be merged.

2. If it's merged into misc-next, move it to the 'In misc-next' stage.

3. Once the series is in Linus's tree the issue can be closed.