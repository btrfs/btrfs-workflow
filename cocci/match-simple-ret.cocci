/*
 * Match unnecessary ret assignment right before return.
 */
@@
expression E;
@@

* ret = E;
* return ret;
