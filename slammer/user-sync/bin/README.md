
## What is SlammerSync?

SlammerSync reads from any data source including databases,
LDAP directories or files and transforms and compares this data to an LDAP
directory. These connectors can then be used to continuously synchronize a data
source to a directory, for a one shot import or just to compare differences by
outputting CSV or LDIF format reports.

SlammerSync offers a powerful transformation engine, based on a scripting language, to
easily manipulate data on the fly.

Various identity management functions are included for directory-specific
compatibility - most notably Active Directory (changing passwords, account
status, last logon, etc ...). 

The main goal is to provide a simple and efficient way of
synchronizing any data source to a LDAP directory quickly.


* Multiple connectors: any LDAPv3 server, any database with a JDBC
  connector, flat files (or anything else you write a connector for)
* Support for LDAPv3 niceties and extensions: StartTLS, LDAPS, paged results,
  schema retrieval, LDAP Sync (rfc4533), LDAP persistent search
* Graphical setup wizard (use is optional)
* Fully configurable through plain text configuration files
* Written in Java, leveraging the ecosystem of available tools
* Simple wrapper shell scripts are provided, to ease use and system integration
* Runs on any Java-enabled platform - tested on Windows, Linux and MacOS X
* Simple attribute mapping from source to destination
* Three policies to update attributes, including forcing values, 
  non-destructive updates and merging
* Advanced attribute manipulation via a built-in Script engine (include
  support for JavaScript and Groovy scripting languages)
* Predefined libraries for use in JavaScript attribute manipulation:
	- LDAP server tools: standard bind operation can be checked on any
	  LDAPv3 server
	- Active Directory tools: password update (unicodePwd attribute),
	  account type and status manipulation (userAccountControl), unused
	  account detection (lastLogonTimestamp)
	- String manipulation: formatting for common tasks in identity
	  management, such as capitalizing first letters in a complex name,
	  filtering accents for login names, etc …
	- Security tools: password hashing, bi-directional encryption
* Conditions to only create, update, rename or delete entries depending on
  current values
* Detailed and configurable logging in LDIF (fully RFC-compliant) and CSV
  formats	
* Monitoring plugin for Nagios
* Possibility to extend any Java class to implement your own specific
  synchronization needs

