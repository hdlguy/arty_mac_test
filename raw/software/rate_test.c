#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<netinet/ip.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<linux/if_packet.h>
#include<net/ethernet.h>
#include <time.h>
#include <unistd.h>

int main ()
{

    printf("This program must be run as root: sudo ./rate_test\n\n");

    // open a raw socket
    int sock_r;
    sock_r=socket(AF_PACKET,SOCK_RAW,htons(ETH_P_ALL));
    if(sock_r<0) {
        printf("error in socket. Are you root?\n");
        return -1;
    } else {
        printf("socket opened, sock_r = %d\n", sock_r);
    }


    // tell the socket to use a particular ethernet adapter
    setsockopt(sock_r, SOL_SOCKET, SO_BINDTODEVICE, "adapter name", strlen("enx94103eb7e201"));


    //Receive network packets
    struct timespec t1, t2;
    double elapsed_time, rate;
    const size_t bufsize = 65536;
    unsigned char *buffer = (unsigned char *) malloc(65536); //to receive data
    memset(buffer,0,bufsize);
    struct sockaddr saddr;
    int saddr_len = sizeof (saddr);
    ssize_t buflen, total_rxlen=0;
    int i = 0;
    while(1) {

        buflen=recvfrom(sock_r, buffer, bufsize, 0, &saddr, (socklen_t *)&saddr_len);
        if(buflen<0) {
            printf("error in reading recvfrom function\n");
            return -1;
        }
        total_rxlen += buflen;

        // occasionally compute the rx throughput.
        if (i%(1024*16) == 0) {

            t1 = t2;
            clock_gettime(CLOCK_MONOTONIC, &t2);
            elapsed_time = (t2.tv_sec - t1.tv_sec) + 1e-9*(t2.tv_nsec - t1.tv_nsec);
            rate = total_rxlen/elapsed_time;
            printf("bytes received = %ld, elapsed seconds = %le, Mbytes/second = %3.2lf, Mbits/second = %3.2lf\n", total_rxlen, elapsed_time, rate/1.0e6, rate*8/1.0e6);
            printf("buflen = %ld: ", buflen); for(int j=0; j<32; j++) printf("%02x",buffer[j]); printf("\n");
            total_rxlen = 0;

        }

        i++;

    }

    return ( 0 );

}
