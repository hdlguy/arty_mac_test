# arty_mac_test
A test design to see if the tri-mode ethernet mac can be used for control and data in a small design.

Two approaches are tested here, raw Ethernet frames and UDP. The Arty A7-35t development board is used in these examples. It provides a 100Mbps Ethernet connection.

## Raw Frames
The Xilinx TEMAC core provides AXI Streaming interfaces for reception and transmission of raw Ethernet frames.  
The raw part of this project demonstrates moving data over these interfaces. An FPGA design for the Arty A7-35t development board is provided along with Linux C language raw socket examples for excercising the design.

Raw frames can only be used when the network connection is point-to-point, normally a PC connected directly to the FPGA board. 

The advantages of raw frames are absolute maximum data transfer rate and extreme simplicity. A disadvantage is that raw socket software must run as root, requiring sudo privileges.

## UDP

UDP is an internet protocol that is commonly used to connect a remote sensor with a control computer.  It has the advantage that it can run through Ethernet switches but is much simpler and more efficient than TCP.

A UDP socket specifies an IP address and an IP port number.  UDP frames reside inside Ethernet and IP frames. The Ethernet frame header requires the MAC address of the destination.  To learn the MAC address of the target device the computer sends an ARP request.
The FPGA design in this project contains logic to detect ARP requests and respond with an ARP reply.

Once the ARP cycle is complete the FPGA can receive and send UDP packets.  The UDP logic of the FPGA strips off all network headers on reception and passes just the UDP payload to the application over an AXI Stream interface.

For transmission, the UDP FPGA logic provides an AXI Stream interface for transmission.  The application need only provide the payload data.  Network headers are added by the logic.

## Performance
Using large 1024 byte frames, the raw interface was able to transmit data at 98Mbps on a 100Mbps connection.

Using variable length frames (1 - 1000 bytes), the UDP logic was able to transmit data at 93Mbps.


## References
https://digilent.com/shop/arty-a7-artix-7-fpga-development-board/
https://homepages.uc.edu/~thomam/Net1/Packet_Formats/
https://www.xilinx.com/products/intellectual-property/temac.html

