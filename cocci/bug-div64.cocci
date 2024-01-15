/*
 * Find where a u64 type is divided using the / operator instead of the div64
 * helpers.
 * Exceptions: division by compile-time power-of-two constants
 */
@@
u64 U64;
expression E;
@@
* U64 / E
