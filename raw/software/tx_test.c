/*
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 */

#include <arpa/inet.h>
#include <linux/if_packet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <netinet/ether.h>
//#include <time.h>
#include <unistd.h>

#define MY_DEST_MAC0	0xff
#define MY_DEST_MAC1	0xff
#define MY_DEST_MAC2	0xff
#define MY_DEST_MAC3	0xff
#define MY_DEST_MAC4	0xff
#define MY_DEST_MAC5	0xff

#define DEFAULT_IF	"enx94103eb7e201"
#define BUF_SIZ		1024

int main(int argc, char *argv[])
{

    printf("This program must be run as root: sudo ./tx_test\n\n");

	int sockfd;
	struct ifreq if_idx;
	struct ifreq if_mac;
	int tx_len = 0;
	char sendbuf[BUF_SIZ];
	struct ether_header *eh = (struct ether_header *) sendbuf;
	//struct iphdr *iph = (struct iphdr *) (sendbuf + sizeof(struct ether_header));
	struct sockaddr_ll socket_address;
	char ifName[IFNAMSIZ];
	
	/* Get interface name */
	if (argc > 1) strcpy(ifName, argv[1]); else strcpy(ifName, DEFAULT_IF);
    printf("ifName = %s\n", ifName);

	/* Open RAW socket to send on */
	if ((sockfd = socket(AF_PACKET, SOCK_RAW, IPPROTO_RAW)) == -1) {
	    perror("socket");
	}

	/* Get the index of the interface to send on */
	memset(&if_idx, 0, sizeof(struct ifreq));
	strncpy(if_idx.ifr_name, ifName, IFNAMSIZ-1);
	if (ioctl(sockfd, SIOCGIFINDEX, &if_idx) < 0)
	    perror("SIOCGIFINDEX");

	/* Get the MAC address of the interface to send on */
	memset(&if_mac, 0, sizeof(struct ifreq));
	strncpy(if_mac.ifr_name, ifName, IFNAMSIZ-1);
	if (ioctl(sockfd, SIOCGIFHWADDR, &if_mac) < 0)
	    perror("SIOCGIFHWADDR");

	/* Construct the Ethernet header */
	memset(sendbuf, 0, BUF_SIZ);
	eh->ether_shost[0] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[0];
	eh->ether_shost[1] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[1];
	eh->ether_shost[2] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[2];
	eh->ether_shost[3] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[3];
	eh->ether_shost[4] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[4];
	eh->ether_shost[5] = ((uint8_t *)&if_mac.ifr_hwaddr.sa_data)[5];
	eh->ether_dhost[0] = MY_DEST_MAC0;
	eh->ether_dhost[1] = MY_DEST_MAC1;
	eh->ether_dhost[2] = MY_DEST_MAC2;
	eh->ether_dhost[3] = MY_DEST_MAC3;
	eh->ether_dhost[4] = MY_DEST_MAC4;
	eh->ether_dhost[5] = MY_DEST_MAC5;

    for(int i=0; i<6; i++) printf("0x%02x, ", eh->ether_shost[i]);
    printf("\n");
    for(int i=0; i<6; i++) printf("0x%02x, ", eh->ether_dhost[i]);
    printf("\n");

	/* Ethertype field */
	eh->ether_type = htons(ETH_P_IP);
	tx_len += sizeof(struct ether_header);

	/* Packet data */
	//sendbuf[tx_len++] = 0xde;
	//sendbuf[tx_len++] = 0xad;
	//sendbuf[tx_len++] = 0xbe;
	//sendbuf[tx_len++] = 0xef;

    const int Ndata = 64;
    for (int i=0; i<Ndata; i++) sendbuf[tx_len++] = 0xff - i;
    sendbuf[14] = 0xfa;
    sendbuf[15] = 0xf3;
    sendbuf[16] = 0xbe;
    sendbuf[17] = 0xfe;
    sendbuf[18] = 0xca;
    sendbuf[19] = 0xfe;

    sendbuf[28] = 0xff;

	/* Index of the network device */
	socket_address.sll_ifindex = if_idx.ifr_ifindex;
	/* Address length*/
	socket_address.sll_halen = ETH_ALEN;
	/* Destination MAC */
	socket_address.sll_addr[0] = MY_DEST_MAC0;
	socket_address.sll_addr[1] = MY_DEST_MAC1;
	socket_address.sll_addr[2] = MY_DEST_MAC2;
	socket_address.sll_addr[3] = MY_DEST_MAC3;
	socket_address.sll_addr[4] = MY_DEST_MAC4;
	socket_address.sll_addr[5] = MY_DEST_MAC5;

	/* Send packets */
    ssize_t send_size;
    int whilecount = 0;
    while(1) {
	    send_size = sendto(sockfd, sendbuf, tx_len, 0, (struct sockaddr*)&socket_address, sizeof(struct sockaddr_ll));
	    if (send_size < 0){
	        printf("Send failed\n");
        } else {
            printf("%d: send_size = %ld\n", whilecount, send_size);
        }
        sendbuf[28] -= 1;

        usleep(1000000);
        whilecount++;
    }

	return 0;
}
