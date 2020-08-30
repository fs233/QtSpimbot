/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

unsigned char *extractMessage(const unsigned char *message_in, int length) {
    // length must be a multiple of 8
    assert((length % 8) == 0);

    // allocate an array for the output
    unsigned char *message_out = new unsigned char[length];
    for (int i = 0; i < length; i++) {
        message_out[i] = 0;
    }
    
    char output;
    char temp;
    char last;
    for(int j = 0; j <length; j++){
       for(int i = 7; i>=0 ;i--){
        temp = message_in[i+8*(j/8)]>>(j%8);
        last = temp & 0b1;
        output = output << 1;
        output = output|last;
      }
    message_out[j] = output;
    }
    return message_out;
}
