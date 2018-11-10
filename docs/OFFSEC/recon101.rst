:Authors: - Diego Perez
          - (@darkquasar)

 .. toctree::
    :maxdepth: 3
    :caption: OFFSEC101
    :name: Recon 01

Recon 101
=========

This module will gather info on how to do basic recon on a target domain. 

Gather network block information
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Excellent idea: download a GEOIP database then unzip and grep by domain!

 .. code:: bash
 
    curl -s http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum2.zip | gunzip | cut -d"," -f3 | sed 's/"//g' | sort -u | grep -i example.com


Now we have the ASN we can lookup all of example.com's IP addresses using whois:

 .. code:: bash
 
    whois -h whois.radb.net -- '-i origin AS00000' | grep -Eo "([0-9.]+){4}/[0-9]+"


Using recon-ng
^^^^^^^^^^^^^^

- There is a marvelous tutorial in https://www.codemetrix.net/practical-osint-recon-ng/
- Another good one in: http://securenetworkmanagement.com/recon-ng-tutorial-part-1/
- List of updated modules: https://resources.infosecinstitute.com/basic-updated-guide-to-recon-ng-plus-new-modules-rundown/#gref

Some basic usage
~~~~~~~~~~~~~~~~

1. Create a Workspace

 .. code:: bash
 
    workspaces add [target]


DNS Recon
^^^^^^^^^

Use DNS Cache Snooping to map domain
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DNS cache snooping is the process of determining whether a given Resource Record (RR) is (or not) present on a given DNS cache.
The most effective way to snoop a DNS cache is using iterative queries. One asks the cache for a given resource record of any type (A, MX, CNAME, PTR, etc.) setting the RD (recursion desired) bit in the query to zero. If the response is cached the response will be valid, else the cache will reply with information of another server that can better answer our query, or most commonly, send back the root.hints file contents.
This may allow a remote attacker to determine which domains have recently been resolved via this name server, and therefore which hosts have been recently visited. Publicly available DNS servers should only response to queries regarding hosts to which they are authoritative.

 .. code:: bash
 
    dig @[SOA IP (ex. 120.5.44.2)] -f updates.list +norecurse | grep -A 2 "ANSWER SECTION" | sort -u | sed '/^$/d'| sed 's/^/[+] Success - /g ' | sed 's/.*ANSWER SECTION.*//'


Find the Authoritative Server (SOA - Start of Authority) for a Domain
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- In Linux use ``dig +short NS stackoverflow.com``
- In Windows use ``nslookup -type=SOA google.com``

Find TLD associated with the current Domain
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This technique can give you many advantages. From a defensive point of view, it allows you to list all TLD whose *host* portion matches with the domain you are investigating, this allows you to build a list of TLDs that you can then query with *whois* to spot any domains *recently registered* (using its "creation date" attribute). The latter can provide indications of targeted campaigns on the build. 
Start with: 

 .. code:: bash
 
    dnsrecon -d domain.com -t tld

then compile a list (small hint ``sed -E -i 's/^.*(domain.*? ).*$/\1/' tld.list``) and continue with: 

 .. code:: bash
 
    for i in `cat similar-tld.list`; do res=`whois $i | grep -Pio "^Creation Date: (.*?)$"`; echo $i - $res; done

