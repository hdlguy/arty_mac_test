#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>

int main(){
    int clientSocket;
    char buffer[1024];
    struct sockaddr_in serverAddr;
    socklen_t addr_size;

    /*Create UDP socket*/
    clientSocket = socket(AF_INET, SOCK_DGRAM, 0);

    /*Configure settings in address struct*/
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(1234);
    serverAddr.sin_addr.s_addr = inet_addr("16.0.0.128");
    memset(serverAddr.sin_zero, '\0', sizeof(serverAddr.sin_zero));  

    /*Initialize size variable to be used later on*/
    addr_size = sizeof(serverAddr);

    //ssize_t nBytes;
    ssize_t maxbytes = 100;
    int i=0;
    while(1){
        for (ssize_t nBytes=12; nBytes<maxbytes; nBytes++) {
            printf("%d: %ld\n", i, nBytes);
            for (int j=0; j<nBytes; j++) buffer[j] = 0x00ff & (j+i);
            sendto(clientSocket, buffer, nBytes, 0, (struct sockaddr *)&serverAddr, addr_size); 
            usleep(100000);
            i++;
        }
    }

    return 0;
}



