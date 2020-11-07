#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t tag = this->get_tag();
  uint32_t offset_size = _cache_config.get_num_block_offset_bits();
  uint32_t index_size =  _cache_config.get_num_index_bits();
  uint32_t address = ((tag<<index_size)+_index)<<offset_size;

  return address;
}
