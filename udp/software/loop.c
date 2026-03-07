#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>

int main(){
    int clientSocket, nBytes;
    char buffer[1024];
    struct sockaddr_in serverAddr;
    socklen_t addr_size;

    /*Create UDP socket*/
    clientSocket = socket(PF_INET, SOCK_DGRAM, 0);

    /*Configure settings in address struct*/
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(1234);
    serverAddr.sin_addr.s_addr = inet_addr("16.0.0.128");
    memset(serverAddr.sin_zero, '\0', sizeof serverAddr.sin_zero);  

    /*Initialize size variable to be used later on*/
    addr_size = sizeof serverAddr;

    while(1){
        printf("Type a sentence to send to server:\n");
        fgets(buffer, 1024, stdin);
        printf("You typed: %s", buffer);

        nBytes = strlen(buffer) + 1;
    
        sendto(clientSocket, buffer, nBytes, 0, (struct sockaddr *)&serverAddr, addr_size); // /*Send message to server*/

        nBytes = recvfrom(clientSocket, buffer, 1024, 0, NULL, NULL); // /*Receive message from server*/

        printf("Received from server: %s\n", buffer);
    }

    return 0;
}



