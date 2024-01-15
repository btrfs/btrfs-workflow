/*
 * Look for open coded power-of-two expressions.
 * The only allowed case is is_power_of_two_u64()
 */
@@
expression E;
@@

* E & (E - 1)
