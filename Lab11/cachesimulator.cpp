#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
  size_t index = extract_index(address, _cache->get_config());
  size_t tag = extract_tag(address, _cache->get_config());
  vector<Cache::Block*> block = _cache->get_blocks_in_set(index);
  for(unsigned i = 0; i<block.size(); i++){
    if(block[i]->get_tag()==tag && block[i]->is_valid()){
      _hits++;
      return block[i];
    }
  }
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
  size_t index = extract_index(address, _cache->get_config());
  size_t tag = extract_tag(address, _cache->get_config());
  vector<Cache::Block*> block = _cache->get_blocks_in_set(index);
  uint32_t oldest_used_time = block[0]->get_last_used_time();
  Cache::Block* oldest_block = block[0];  
  for(unsigned i = 0; i<block.size(); i++){
    if(!block[i]->is_valid()){
      block[i]->set_tag(tag);
      block[i]->read_data_from_memory(_memory);
      block[i]->mark_as_valid();
      block[i]->mark_as_clean();
      return block[i];
    }
    if(block[i]->get_last_used_time() < oldest_used_time){
      oldest_block = block[i];
      oldest_used_time = block[i]->get_last_used_time();
    }
  }
  if(oldest_block->is_dirty()){
    oldest_block->write_data_to_memory(_memory);
  } 
  oldest_block->set_tag(tag);
  oldest_block->read_data_from_memory(_memory);
  oldest_block->mark_as_valid();
  oldest_block->mark_as_clean();
  return oldest_block;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
  Cache::Block* block = find_block(address);
  if(block==NULL){
    block = bring_block_into_cache(address);
  }
  _use_clock++;
  block->set_last_used_time(_use_clock.get_count());
  return block->read_word_at_offset(extract_block_offset(address, _cache->get_config()));
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
  Cache::Block* block = find_block(address);
  if(block==NULL){
    if(_policy.is_write_allocate()){
      block = bring_block_into_cache(address);
    }else{
      _memory->write_word(address, word);
      return;
    }
  }
  _use_clock++;
  block->set_last_used_time(_use_clock.get_count());
  block->write_word_at_offset(word, extract_block_offset(address, _cache->get_config()));
  if(_policy.is_write_back()){
    block->mark_as_dirty();
  }else{
    _memory->write_word(address, word);
  }
}
