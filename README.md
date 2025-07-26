# check_isp_connect
This is a very basic Nagios/Icinga plugin which should perform some basic checks regarding ISP/internet connectivity. 
This can be handy on gateways to trigger alarms when there is an ISP failure.

The first check doing a ping using a hostname/URL, hence relies on the fact that DNS is working. It is important that this hostname/URL must provide response via ping aka ICMP Echo Requests.
Here is an example for github.com out of Germany

````
$ ping github.com
PING github.com (140.82.121.3) 56(84) bytes of data.
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=1 ttl=54 time=20.7 ms
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=2 ttl=54 time=24.2 ms
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=3 ttl=54 time=22.5 ms
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=4 ttl=54 time=20.0 ms
^C
--- github.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 19.971/21.853/24.205/1.639 ms
$ 
````

If that one fails, the 2nd check will ping a configurable IP address. Famous DNS servers are a good choice to start here. Again, it is key that this IP address does respond to ping aka ICMP Echo Requests.

````
$ ping 8.8.4.4
PING 8.8.4.4 (8.8.4.4) 56(84) bytes of data.
64 bytes from 8.8.4.4: icmp_seq=1 ttl=116 time=32.1 ms
64 bytes from 8.8.4.4: icmp_seq=2 ttl=116 time=19.2 ms
64 bytes from 8.8.4.4: icmp_seq=3 ttl=116 time=16.9 ms
64 bytes from 8.8.4.4: icmp_seq=4 ttl=116 time=21.7 ms
^C
--- 8.8.4.4 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 16.949/22.509/32.117/5.799 ms
$ 
````

And this is how it looks like from the plugin perspective
````
$ ./check_isp_connect.sh -u github.com -i 8.8.4.4
OK - Looks ok (github.com and 8.8.4.4 are reachable)
$
$ ./check_isp_connect.sh -u git2hub.com -i 8.8.4.4
WARNING - DNS does not work but 8.8.4.4 is reachable
$
$ ./check_isp_connect.sh -u git2hub.com -i 8.8.4.2
CRITICAL - checks on git2hub.com but 8.8.4.2 failed
$
````
