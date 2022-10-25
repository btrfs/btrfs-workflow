// Find declared functions that aren't actually called by anybody.
//
// This can give you false positives so you still need to check the code to see
// if it's not actually used, call it with all of the source files, so for
// example like this
//
// spatch -sp_file ./unused.cocci --include-headers --timeout 600 \
//		fs/btrfs/*.c fs/btrfs/*.h
//
// This is pretty heavy for matching, so if you get timeout messages just
// increase the timeout.

@funcproto@
identifier func;
type T;
position p0;
@@

T func@p0(...);

@funccall@
identifier funcproto.func;
@@

(
func(...)
|
func
)

@script:python depends on !funccall@
p0 << funcproto.p0;
f << funcproto.func;
@@
print("Proto at %s:%s with no usage" % (p0[0].file, p0[0].line))
print(f)
