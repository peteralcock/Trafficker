package main

import (
	"fmt"
	"log"

	"gopkg.in/ldap.v2"
)

const (
	host    = "nypd.example.com"
	port    = 389
	aliceDn = "uid=barbrady,ou=people,dc=nypd,dc=example,dc=com"
)

func main() {
	l, err := ldap.Dial("tcp", fmt.Sprintf("%s:%d", host, port))
	if err != nil {
		log.Fatalf("Failed to connect %v", err)
	}
	defer l.Close()

	l.Debug = true

	// authenticate a user. the object has to have a `userPassword` property.
	err = l.Bind(aliceDn, "password")
	if err != nil {
		log.Fatalf("Failed to bind: %v", err)
	}
}

