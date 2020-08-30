/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
  unsigned right = input & 0x55555555;
  unsigned left = input & 0xAAAAAAAA;
  left = left >> 1;
  input = left + right;
  right = input & 0x33333333;
  left = input & 0xCCCCCCCC;
  left = left >> 2;
  input = left + right;
  right = input & 0x0F0F0F0F;
  left = input & 0xF0F0F0F0;
  left = left >> 4;
  input = left + right;
  right = input & 0x00FF00FF;
  left = input & 0xFF00FF00;
  left = left >> 8;
  input = left + right;
  right = input & 0x0000FFFF;
  left = input & 0xFFFF0000;
  left = left >> 16;
  input = left + right;
	return input;
}
