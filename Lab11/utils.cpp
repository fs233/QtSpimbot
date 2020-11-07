#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offset = cache_config.get_num_block_offset_bits();
  uint32_t set_index = cache_config.get_num_index_bits();
  if(offset+set_index>31){
    return 0;
  }
  return address>>(offset+set_index);
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offset = cache_config.get_num_block_offset_bits();
  uint32_t tag = cache_config.get_num_tag_bits();
  if(tag+offset>31){
    return 0;
  }
  return (address<<tag)>>(tag+offset);
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t set_index = cache_config.get_num_index_bits();
  uint32_t tag = cache_config.get_num_tag_bits();
  if(set_index+tag>31){
    return 0;
  }
  return (address<<(set_index+tag))>>(set_index+tag);
}
