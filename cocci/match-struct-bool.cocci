/*
 * Find bool members in structures. If there are a few they can be converted to
 * bool bitfields.
 */
@@
identifier STRUCT, MEMBER;
@@

* struct STRUCT {
  ...
* bool MEMBER;
  ...
* };
