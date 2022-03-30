// GOOD: One operation on the hostnames table.

if(hostnames.TryGetValue(ip, out hostname))
  return hostname;
