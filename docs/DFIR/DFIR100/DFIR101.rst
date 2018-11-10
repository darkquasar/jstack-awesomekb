:Authors: - Diego Perez
          - (@darkquasar)
    
 .. toctree::
    :maxdepth: 3
    :caption: DFIR101
    :name: DFIR101

Incident Response 101
=====================

Concepts
--------

  A hole in a mathematical object is a topological structure which prevents the object from being continuously shrunk to a point. When dealing with topological spaces, a disconnectivity is interpreted as a hole in the space.
  
  *Weisstein, Eric W. "Hole." From MathWorld*

 .. note:: 

    A good mnemonic is **PICERL**: Preparation, Identification (Analysis and Scoping), Containment (Intel Development too), Eradication, Recovery, Lessons Learned.

One of the main problems organizations face is to go from *identification and scoping* to *eradication* when it comes to active intruders in their networks. Companies with no defined IR framework and playbooks usually go for the easy solution: pulling the plug. However, this is the wrong approach. You miss the opportunity to fully understand **what** the attacker is doing, **where** it has been and **how** it behaves in your network. Instead of "pulling the plug" we should aim to perform **"Active Defense"** (full scale network/host monitoring, canaries, honeypots, data decoy, bit mangling, network segmentation), that is, your responder's tactics adapt to the adversary as the attack progresses. Defenders shouldn't think in graphs, they should think topologically

In IR, you need to aim to be "close enough" to certainty rather than cientifically exact. You may be wrong later, but by its very concept, IR means you will be defining *areas* of risk and move within a **spectrum of certainty**.

Intelligence-Driven Incident Response
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is a loop that helps define what a strategic approach might be. It consists of a feedback between the **identification/intelligence/scoping** and **containment/intelligence development** phases. 

 .. figure:: ./img/Intelligence-IR.png

    Intelligence-Driven-IR
    https://www.sans.org/cyber-security-summit/archives/file/summit-archive-1492558649.pdf
    Copyright: Rob Lee - SANS

Remediation Cycle
^^^^^^^^^^^^^^^^^

Remmediation is a continuous process: 

- Deny access
- Restrict reaction
- Deteriorate survivability

Some measures might include:

- Block IP addresses or create DNS sinkholes for known C2s
- Dynamic network segmentation
- Restrict access of known compromised accounts (remove rights, change password, deactivate)
- Change your AD krbtgt password to thwart golden tickets

Risk
^^^^

Risk
 it is comprised of **threat, vulnerability and consequence (impact)**.
 Risk is commonly defined as threat times vulnerability times consequence. This formula applies to anything that could be exposing you to danger, but when applied to cybersecurity—the unique risks individuals and businesses face as a result of using interconnected technological systems—it provides us with a great deal of insight on risk mitigation.
 Source: `Cybersecurity Risk: A Thorough Definition <https://www.bitsighttech.com/blog/cybersecurity-risk-thorough-definition>_`

 .. note:: Threat is composed of **intent**, **oportunity** and **capability**
 

Lockheed Martin's Cyber Kill Chain
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We all know this one :)

 .. figure:: ./img/CyberKillChain.png


