#include "simplecache.h"
#include <iostream>

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  std::vector< SimpleCacheBlock > cur_blockvec = _cache[index];
  for(unsigned i = 0; i < cur_blockvec.size(); i++){
    if(cur_blockvec[i].tag()==tag && cur_blockvec[i].valid()){
      return cur_blockvec[i].get_byte(block_offset);
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
  std::vector< SimpleCacheBlock > &cur = _cache[index];
  for(unsigned i = 0; i < cur.size(); i++){
    if(!cur[i].valid()){
      cur[i].replace(tag, data);
      return;
    }
  }
  cur[0].replace(tag, data);
}
