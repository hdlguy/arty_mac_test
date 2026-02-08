import socket
import time

print("hello!")

msgFromClient       = "01234567?9"
serverAddressPort   = ("16.0.0.128", 1234)

UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

j = 0;
while True:
    print(j)
    UDPClientSocket.sendto(str.encode(msgFromClient), serverAddressPort)
    time.sleep(1.0)
    j=j+1

