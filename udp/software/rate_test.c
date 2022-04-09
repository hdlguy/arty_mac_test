
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

int main(){
    int clientSocket;
    char buffer[1024];
    struct sockaddr_in serverAddr;
    //socklen_t addr_size;

    /*Create UDP socket*/
    clientSocket = socket(PF_INET, SOCK_DGRAM, 0);

    /*Configure settings in address struct*/
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(1234);
    serverAddr.sin_addr.s_addr = inet_addr("16.0.0.128");
    memset(serverAddr.sin_zero, '\0', sizeof serverAddr.sin_zero);  

    // send one packet to prime the pump.
    socklen_t addr_size = sizeof serverAddr;
    strcpy(buffer, "0123456789");
    ssize_t nBytes = strlen(buffer);
    sendto(clientSocket, buffer, nBytes, 0, (struct sockaddr *)&serverAddr, addr_size); // /*Send message to server*/

    struct timespec t1, t2;
    double elapsed_time, rate;
    int i = 0;
    ssize_t buflen, total_rxlen=0;
    while(1){

        buflen = recvfrom(clientSocket, buffer, 1024, 0, NULL, NULL); // /*Receive message from server*/
        if(buflen<0) {
            printf("error in reading recvfrom function\n");
            return -1;
        }
        total_rxlen += buflen;

        // occasionally compute the rx throughput.
        if (i%(1024*32) == 0) {

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

    return 0;
}


/*
*/
