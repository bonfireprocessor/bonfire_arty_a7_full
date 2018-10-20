#include "bonfire.h"

#define PATTERN 0x0ABCD


inline uint16_t rotate4(uint16_t p)
{
uint32_t t = p  >> 12; // shift uppper nibble to lowest nibble  
  
  return (p << 4) | t;      
}



// Fills memory with a pattern
// Upper 16 bit if the word will contain the address of the cell
// Lower 16 Bit is a rotating pattern of Hex ABCD rotated by one nibble in every cell
void writepattern(void *mem,int len)
{
uint32_t *pmem = mem;
int i;
uint16_t magic = PATTERN;

   for(i=0;i<len;i++) {
      
     pmem[i] = ((uint32_t)&pmem[i] << 16   & 0x0ffff0000) | magic;
     magic = rotate4(magic);       
   } 
    
}

int verifypattern(void *mem, int len)
{
uint32_t *pmem = mem;
int i;
uint32_t magic = PATTERN;
uint32_t comp;

int errcount=0;

   for(i=0;i<len;i++) {
     
     comp =  ((uint32_t)&pmem[i] << 16   & 0x0ffff0000 ) | magic; 
     if (pmem[i] != comp) errcount++;
     magic = rotate4(magic);       
   }     
   return errcount; 
}

