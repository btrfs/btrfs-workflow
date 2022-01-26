/*
 * Detect chain initializations. Suggested fix is to use the simplest variable to
 * initialize the rest (needs manual review):
 *
 * a = b = c = func();
 */
@@
expression I1, I2, I3, I4;
expression E;
@@

(
- I1 = I2 = I3 = I4 = E;
+ I1 = E;
+ I2 = I1;
+ I3 = I1;
+ I4 = I1;
|
- I1 = I2 = I3 = E;
+ I1 = E;
+ I2 = I1;
+ I3 = I1;
|
- I1 = I2 = E;
+ I1 = E;
+ I2 = I1;
)
