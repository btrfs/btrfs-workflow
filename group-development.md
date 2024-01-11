# Btrfs group development

We are shifting to a group development model instead of the traditional
maintainer development model.  Previously we submitted patches based on the
[patch submission guidelines](patch-submission.md), and then a maintainer would
merge them when and where they seemed appropriate.  The general guidelines found
in the patch submission document still hold true, but we're moving toward a
system where longterm developers are responsible for checking in their own code
to the appropriate branch.

The repo for this is

[https://github.com/btrfs/linux](https://github.com/btrfs/linux)

We are going to use two branches

 - `for-next`: This is code that needs testing and will go into the next merge
   window.
 - `for-linus`: This is the code that needs to go to Linus in the next pull
   request.  When we get close to the merge window `for-next` will become
   `for-linus`.

Generally speaking developers will be checking things into `for-next` unless
they're urgent fixes that need to go into Linus quickly.

## tl;dr developer workflow

1. Write code off of your base.
2. Merge the `ci` branch from the btrfs tree.
3. Push to your local repo, submit a pull request against the base branch.
4. Submit your patches to linux-btrfs@vger.kernel.org.
5. Await clean CI run and patch reviews.
6. Once the CI run is clean and you have the required `Reviewed-by`'s, run `git
   reset --merge HEAD~1` to strip off the `ci` branch and merge your code into
   the base branch, either through the github UI or via git push.

## Who should review my patches?

Another member of the development team.  Outside developer `Reviewed-by`'s
should be appropriately included, but you must have a `Reviewed-by` from a
committing member in order to commit your own code.

For big features you must have at least 2 `Reviewed-by`'s from a committing
member in order to commit your code.  You must also have fstests that will test
your code in the CI that run when you test your code.

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
7. Pray you didn't break anything.
8. Let everybody know you're done force pushing.

## What about outside contributors?

For outside contributors any one of the committing members may merge their
patches, but must have an additional `Reviewed-by` from another committing
member.  The committing member must still follow the same process to make sure
the code is properly tested and validated before merging.
