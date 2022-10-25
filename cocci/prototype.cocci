// Find function prototypes that do not have any corresponding function
// definition.  This is annoying to run since you need to get all the headers
// and c files to be processed at the same time, the normal "one file at a time"
// will make all header files look like they have prototypes without code.  Thus
// you must run it something like this
//
// spatch -sp_file ./prototype.cocci --include-headers fs/btrfs/*.c fs/btrfs/*.h
//
// Alternatively you can use this to find prototypes that are defined in headers
// that don't have their corresponding code in that given source file, so for
// instance
//
// spatch -sp_file ./prototype.cocci fs/btrfs/extent_io.h fs/btrfs/extent_io.c
//
// would spit out a prototype for a function that's defined in extent_io.h, but
// it's code isn't found in extent_io.c, whereas the first command wouldn't
// complain because it finds the code in one of the other source files.

@funcproto@
identifier func;
type T;
position p0;
@@

T func@p0(...);

@funccode@
identifier funcproto.func;
position p1;
@@

func@p1(...) { ... }

@script:python depends on !funccode@
p0 << funcproto.p0;
@@
print("Proto with no function at %s:%s" % (p0[0].file, p0[0].line))
