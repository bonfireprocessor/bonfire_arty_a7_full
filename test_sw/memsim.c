#include "bonfire.h"

#include "mempattern.h"

volatile uint32_t *mon_port = (uint32_t*)WISHBONE_IO_SPACE;

#define CACHE_BYTELANES 16  // Width of Cache Word in Bytes
#define LINE_SIZE 4 // Width of Cache Line Size in Cache Words
#define CACHE_SIZE (2048*CACHE_BYTELANES) // Cache Size in Bytes !!

#define LINE_SIZE_BYTES (LINE_SIZE*CACHE_BYTELANES)


int main()
{
int errors;
    
   while(1) {
	 mon_port[2]=0x103;  // Program signature
     mon_port[1]=1; 
     writepattern(DRAM_BASE,LINE_SIZE_BYTES/4);
     mon_port[1]=2; 
     writepattern((void*)DRAM_BASE+LINE_SIZE_BYTES,LINE_SIZE_BYTES/4); // force line switch
     mon_port[1]=3; 
     errors=verifypattern(DRAM_BASE,LINE_SIZE_BYTES/4);  
     mon_port[3]=errors;
     mon_port[1]=4; 
     errors+=verifypattern((void*)DRAM_BASE+LINE_SIZE_BYTES,LINE_SIZE_BYTES/4);   // force line switch
     mon_port[3]=errors;
     mon_port[1]=5;
     // Force Cache wrap - and therefore writeback
     writepattern((void*)DRAM_BASE+CACHE_SIZE,LINE_SIZE_BYTES/4);
     mon_port[1]=6; 
     errors+=verifypattern((void*)DRAM_BASE,LINE_SIZE_BYTES/4); // Force another writeback
     mon_port[3]=errors;
     mon_port[1]=7; 
     errors+=verifypattern((void*)DRAM_BASE+CACHE_SIZE,LINE_SIZE_BYTES/4); 
     
     mon_port[0]=errors; // Output error count
    
   } 
    
}
