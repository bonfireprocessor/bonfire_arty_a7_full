
#include "bonfire.h"




#include <stdint.h>
#include <stdbool.h>


#include "platform.h"

#define UART_TX 0
#define UART_RECV 0
#define UART_STATUS 1
#define UART_CONTROL 2




volatile uint32_t *uartadr=(uint32_t *)AXI_IO_SPACE;

static uint32_t framing_errors = 0L;


void wait(long nWait)
{
static volatile int c;

  c=0;
  while (c++ < nWait);
}



void writechar(char c)
{

#ifdef  ENABLE_SEND_DELAY
   wait(1000);
#endif
  while (!(uartadr[UART_STATUS] & 0x2)); // Wait while transmit buffer full
  uartadr[UART_TX]=(uint32_t)c;

}

char readchar()
{
uint32_t rx_data;
	
  while (!(uartadr[UART_STATUS] & 0x01)); // Wait while receive buffer empty
  rx_data=uartadr[UART_RECV];
  if (rx_data & 0x80000000) framing_errors++;
  return (char)rx_data;
}


int wait_receive(long timeout)
{
uint8_t status;
bool forever = timeout < 0;

  do {
    status=uartadr[UART_STATUS];
 
    if (status & 0x01) { // receive buffer not empty?
      return uartadr[UART_RECV];
    } else
      timeout--;

  }while(forever ||  timeout>=0 );
  return -1;

}



void writestr(char *p)
{
  while (*p) {
    writechar(*p);
    p++;
  }
}


// Like Writestr but expands \n to \n\r
void write_console(char *p)
{
   while (*p) {
    if (*p=='\n') writechar('\r');
    writechar(*p);
    p++;
  }

}

void writeHex(uint32_t v)
{
int i;
uint8_t nibble;
char c;


   for(i=7;i>=0;i--) {
     nibble = (v >> (i*4)) & 0x0f;
     if (nibble<=9)
       c=(char)(nibble + '0');
     else
       c=(char)(nibble-10+'A');

     writechar(c);
   }
}


static uint16_t l_divisor=0;

void _setDivisor(uint32_t divisor){

   l_divisor = divisor;
   uartadr[UART_CONTROL]= 0x030000L | (uint16_t)divisor; // Set Baudrate divisor and enable port and set extended mode
}

void setDivisor(uint32_t divisor)
{
    _setDivisor(divisor);
}

uint32_t getDivisor()
{
  return l_divisor;
}

void setBaudRate(int baudrate) {


   setDivisor(SYSCLK / baudrate -1);
}


volatile uint32_t *mon_port = (uint32_t*)WISHBONE_IO_SPACE;

int main()
{
char c;


  setBaudRate(500000);
  writestr("The quick brown fox\n");
  
  while ((c=readchar())!='\n') {
	mon_port[1]=c;  
  } 	  
  mon_port[0]=framing_errors;
  return 0;
}

