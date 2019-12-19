# DuckDNS.org account: my-email@gmail.com
echo url="https://www.duckdns.org/update?domains=web1&token=xxx&ip=" | curl -k -o ~/duckdns/duck.log -K -
echo url="https://www.duckdns.org/update?domains=web2&token=xxx&ip=" | curl -k -o ~/duckdns/duck.log -K -
echo url="https://www.duckdns.org/update?domains=web3&token=xxx&ip=" | curl -k -o ~/duckdns/duck.log -K -
echo url="https://www.duckdns.org/update?domains=web4&token=xxx&ip=" | curl -k -o ~/duckdns/duck.log -K -
