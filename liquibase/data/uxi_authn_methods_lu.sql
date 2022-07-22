-- liquibase formatted sql

-- changeset gotsysdba:Initial runAlways:true
truncate table UXI_AUTHN_METHODS_LU;
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (1,'Application Express Accounts','Application Express Accounts are user accounts that are created within and managed in the Oracle Application Express user repository. When you use this method, your application is authenticated against these accounts.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (2,'Custom Authentication','Creating a Custom Authentication scheme from scratch to have complete control over your authentication interface.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (3,'Database Accounts','Database Account Credentials authentication utilizes database schema accounts to authenticate users.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (4,'No Authentication','Adopts the current database user.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (5,'Oracle Application Server Single Sign-On Server','Delegates authentication to the Oracle AS Single Sign-On (SSO) Server. To use this authentication scheme, your site must have been registered as a partner application with the SSO server.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (6,'HTTP Header Variable','Authenticate users externally by storing the username in a HTTP Header variable set by the web server.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (7,'LDAP Directory','Authenticate a user and password with an authentication request to a LDAP server.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (8,'Open Door Credentials','Enable anyone to access your application using a built-in login page that captures a user name.');
insert into UXI_AUTHN_METHODS_LU (ID,METHOD,DESCRIPTION) values (9,'Social Sign-In','Supports authentication with Google, Facebook, and other social network that supports OpenID Connect or OAuth2 standards.');