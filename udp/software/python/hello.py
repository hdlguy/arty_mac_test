import socket

print("hello!")

msgFromClient       = "01234567w9"
bytesToSend         = str.encode(msgFromClient)
serverAddressPort   = ("16.0.0.128", 1234)
bufferSize          = 1024

UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

UDPClientSocket.sendto(bytesToSend, serverAddressPort)

#msgFromServer = UDPClientSocket.recvfrom(bufferSize)
#msg = "Message from Server {}".format(msgFromServer[0])
#print(msg)