/*
 * Match explicit type cast to a type. Many cases are valid, sometimes it's
 * unnecessary or even wrong.
 */
@@
type TYPE;
expression E;
@@

* (TYPE *)(E)
