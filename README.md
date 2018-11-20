# J-Stack AwesomeKB
**Your own, private, available from anywhere, 24x7, 2FA Knowledge Base!**

## Summary
The Jaguar Stack AwesomeKB is a small project that solves a pain point in relation to *free, private, secure and flexible* **knowledge documentation**. It's based in Docker to provide abstraction and versatility as well as easy deployment. The KB is comprised of the following elements:

* Docker for isolation, security, simplicity
* Sphinx to build the documentation from .rst or .md files as well as full-text search
* Authelia for 2FA and Granular Access Control
* AWS for continuous availability and EC2 free-tier facility
* LDAP server for basic IAM (you can create users and control their access to one or many KBs as well as sections within them)
* NGINX to serve the KBs as well as reverse-proxy abstraction
* Redis and Mongo (required by Authelia)

I’ve kept multiple types of KBs along the years: *word documents, simple text files, OneNote, privately hosted wikis*, etc. The problem with these solutions is that they are either **not scalable** (simple documents), **not available** from everywhere (locally hosted), **not elegant** (wikis), **cumbersome** (OneNote), **not free** (private ReadTheDocs), **not automation-friendly** (most of them), **not code friendly** (some of them). I needed a solution that complied with the following requirements:

1. **Markdown AND reStructuredText** friendly
2. **Programmatic**, that is, allowing automation of some or all of the processes involved in producing documentation
3. **Code friendly** (GitHub, GitLab)
4. **Graph friendly** (I would like to be able to embed/display plotly-style graphs created with my Jupyter Notebooks)
5. **Secure**: 2FA
6. **Flexible Access Control** and Identity Management: what if I want to give someone access to a subsection of my KB?
7. **Available 24x7x365**
8. **Full Text Search**
9. **Version Control**
10. **FREE!** Yes, as in what William Wallace wanted for Scotland. If not completely free, at least *at the lowest cost possible*.
11. **Low footprint** (ideally running on less than 512MB RAM)

# How to deploy it?
There is an article in [eideon.com] that is a companion to this repo were I explain with great detail how to deploy your own **AwesomeKB**. Please check it out here: https://www.eideon.com/2018-11-10-THL04-AwesomeKB/

## Easy Deploy
**[this is a snip from the article referenced above]** 
You can easily have your KB up and running by following these two steps:

1. Clone the repo:
   ```bash
   git clone https://darkquasar@github.com/darkquasar/jstack-awesomekb
   ```
   
2. Deploy it all:
   ```bash
   cd jstack-awesomekb
   sudo ./deploy.sh deploy-all
   ```
This will get your KB up and running!

You still need to do some basic config as per [here](https://www.eideon.com/2018-11-10-THL04-AwesomeKB/#6-accessing-your-awesomekb) but it's easy stuff.

# Credits

All I’ve done is cobbling up some things together in an attempt of doing some SecDevOps work. Credit goes in all honesty to:

* Authelia developer, [Clément Michaud](https://github.com/clems4ever) who not only created the app but also already had a docker-compose with the initial features configured.
* [Carlos Perez](https://twitter.com/carlos_perez) (darkoperator) who inspired me to pursue the *automation way* for KBs in his [article](https://www.darkoperator.com/blog/2017/12/10/nmba1hrmndda8m3eo7ipoh7bxvphz4).
* Docker and Sphinx community
* stackoverflow.com (oh yeah!)
