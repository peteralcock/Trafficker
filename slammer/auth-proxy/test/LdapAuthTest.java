// This is a prototype of the readonly ActiveDirectory Java connector. It checks to find a given username against the LDAP URI

import java.util.*;
import javax.naming.*;
import java.util.regex.*;
import javax.naming.directory.*;

public class LdapAuthTest {
    private final static String ldapURI = "ldap://ldap.eclecticlabs.dev:389";
    private final static String ldapBaseDN = "dc=corp,dc=eclecticlabs,dc=com";
    private final static String contextFactory = "com.sun.jndi.ldap.LdapCtxFactory";

    private static DirContext ldapContext () throws Exception {
        Hashtable<String,String> env = new Hashtable <String,String>();
        return ldapContext(env);
    }

    private static DirContext ldapContext (Hashtable <String,String>env) throws Exception {
        env.put(Context.INITIAL_CONTEXT_FACTORY, contextFactory);
        env.put(Context.PROVIDER_URL, ldapURI);
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "cn=readonly,dc=corp,dc=eclecticlabs,dc=com");
        env.put(Context.SECURITY_CREDENTIALS, "readonly");

        DirContext ctx = new InitialDirContext(env);
        return ctx;
    }

    private static String getUid (String user) throws Exception {
        DirContext ctx = ldapContext();
        String filter = "(mail=" + user + ")";
        SearchControls ctrl = new SearchControls();
        ctrl.setSearchScope(SearchControls.SUBTREE_SCOPE);

        NamingEnumeration answer = ctx.search(ldapBaseDN, filter, ctrl);

        String dn;
        if (answer.hasMore()) {
            SearchResult result = (SearchResult) answer.next();
            dn = result.getNameInNamespace();
        }
        else {
            dn = null;
        }
        answer.close();
        return dn;
    }

    private static boolean testBind (String dn, String password) throws Exception {
        Hashtable<String,String> env = new Hashtable <String,String>();
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, dn);
        env.put(Context.SECURITY_CREDENTIALS, password);


        try {
            ldapContext(env);
        }
        catch (javax.naming.AuthenticationException e) {
            return false;
        }
        return true;
    }

    public static void main(String args[]) throws Exception {
        if (args.length != 2) {
            System.out.println( "missing username and password" );
            System.exit(1);
        }

        String user = args[0];
        String password = args[1];
        String dn = getUid( user );

        if (dn != null) {
			/* Found user - test password */
            if ( testBind( dn, password ) ) {
                System.out.println( "user '" + user + "' was found!" );
                System.exit(0);
            }
            else {
                System.out.println( "user '" + user + "' does not exist..." );
                System.exit(1);
            }
        }
        else {
            System.out.println( "user '" + user + "' does not exist..." );
            System.exit(1);
        }
    }
}