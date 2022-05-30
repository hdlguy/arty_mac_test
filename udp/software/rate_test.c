// Server side implementation of UDP client-server model
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <time.h>
   
#define PORT    1234
#define MAXLINE 2048
   
int main() {
    int sockfd;
    uint8_t buffer[MAXLINE];
    struct sockaddr_in servaddr, cliaddr;
       
    // Creating socket file descriptor
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
       
    memset(&servaddr, 0, sizeof(servaddr));
    memset(&cliaddr, 0, sizeof(cliaddr));
       
    // Filling server information
    servaddr.sin_family    = AF_INET; // IPv4
    servaddr.sin_addr.s_addr = INADDR_ANY;
    servaddr.sin_port = htons(PORT);
    //memset(serverAddr.sin_zero, '\0', sizeof(serverAddr.sin_zero));  
       
    // Bind the socket with the server address
    if ( bind(sockfd, (const struct sockaddr *)&servaddr, sizeof(servaddr)) < 0 ) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
       
    socklen_t len;
    len = sizeof(cliaddr);  //len is value/result

    //socklen_t addr_size = sizeof(servaddr);
    //int Nsend = 4*16;
    //for (int i=0; i<Nsend; i++) sendbuf[i] = 0xff;
    //sendto(sockfd, (char *)sendbuf, Nsend, 0, (struct sockaddr *)&servaddr, addr_size);
   
    printf("rate_test: remember to turn on SW0.\n");
    struct timespec t1, t2;
    double elapsed_time, rate;
    ssize_t buflen, total_rxlen=0;
    uint32_t i = 0;
    while(1) {

        buflen = recvfrom(sockfd, (char *)buffer, MAXLINE, MSG_WAITALL, ( struct sockaddr *) &cliaddr, &len);
        if(buflen<0) {
            printf("error in reading recvfrom function\n");
            return -1;
        }
        total_rxlen += buflen;

        // occasionally compute the rx throughput.
        if (i%(1024*32-1) == 0) {

            t1 = t2;
            clock_gettime(CLOCK_MONOTONIC, &t2);
            elapsed_time = (t2.tv_sec - t1.tv_sec) + 1e-9*(t2.tv_nsec - t1.tv_nsec);
            rate = total_rxlen/elapsed_time;
            printf("bytes received = %ld, elapsed seconds = %le, Mbytes/second = %3.2lf, Mbits/second = %3.2lf\n", total_rxlen, elapsed_time, rate/1.0e6, rate*8/1.0e6);
            printf("buflen = %ld: ", buflen); for(int j=0; j<10; j++) printf("%02x", buffer[j]); printf("\n");
            total_rxlen = 0;

            //sendbuf[8] += 1;
            //sendto(sockfd, (char *)sendbuf, Nsend, 0, (struct sockaddr *)&servaddr, addr_size);

        }

        i++;

    }
       
    return 0;
}

