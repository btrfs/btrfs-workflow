/*
 * Match simple function call wrappers.
 */
@@
identifier FUNC, CALL;
type TYPE;
@@

  TYPE
  FUNC(...)
  {
*   return CALL(...);
  }
