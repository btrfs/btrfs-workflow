/*
 * Look for patterns like:
 *
 *   if (!unlikely(...))
 *
 * or
 *
 *   if (!likely(...))
 */

@ disable unlikely @
expression E;
@@

(
* !unlikely(E)
|
* !likely(E)
)
