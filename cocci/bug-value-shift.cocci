/*
 * Catch expresssions mixing up shifts and multpilication
 */
@@
expression E1, E2;
@@
(
* (E1) >> (E2)->sectorsize
|
* (E1) << (E2)->sectorsize
|
* (E1) * (E2)->sectorsize_bits
|
* (E1) / (E2)->sectorsize_bits
|
* (E1) <<= (E2)->sectorsize
|
* (E1) >>= (E2)->sectorsize
|
* (E1) * (E2)->zone_size_shift
|
* (E1) / (E2)->zone_size_shift
)
