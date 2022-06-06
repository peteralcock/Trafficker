
## SlammerSync

Reads from any data source including databases, LDAP directories or files and transforms and compares this data to an LDAP
directory. These connectors can then be used to continuously synchronize a data source to a directory, for a one shot import or just to compare differences by outputting CSV or LDIF format reports. Various identity management functions are included for directory-specific compatibility - most notably Active Directory (changing passwords, account status, last logon, etc ...). The main goal is to provide a simple and efficient way of synchronizing any data source to a LDAP directory quickly.


* Multiple connectors: any LDAPv3 server, any database with a JDBC
  connector, flat files (or anything else you write a connector for)
* Support for LDAPv3 niceties and extensions: StartTLS, LDAPS, paged results,
  schema retrieval, LDAP Sync (rfc4533), LDAP persistent search
* Policies to update attributes, including forcing values, 
  non-destructive updates and merging
* Conditions to only create, update, rename or delete entries depending on
  current values

