#!/usr/bin/env groovy

import groovy.xml.XmlUtil

def standaloneFile = new File("/usr/local/jboss/standalone/configuration/standalone-apelondts-mysql.xml")
def localhost = "localhost"

def addr = InetAddress.getLocalHost()
java.net.InetAddress[] addresses=InetAddress.getAllByName(addr.getHostName())

for (address in addresses) {
	if (!(address.getHostAddress().startsWith("0"))) {
		localhost = address.getHostAddress()
	}
}

/**
 * update standalone.xml
 */
def xmlStandaloneFile = new XmlSlurper(false, false).parse(standaloneFile)

xmlStandaloneFile.interfaces.interface.'inet-address'.find{
	if (it.@value == '${jboss.bind.address.management:127.0.0.1}'){
		println "set 'jboss.bind.address.management' value: ${localhost}"
		it.@value = '${jboss.bind.address.management:' + "${localhost}" + "}"
	}
	if (it.@value == '${jboss.bind.address:127.0.0.1}'){
		println "set 'jboss.bind.address' value: ${localhost}"
		it.@value = '${jboss.bind.address:' + "${localhost}" + "}"
	}
	if (it.@value == '${jboss.bind.address.unsecure:127.0.0.1}'){
		println "set 'jboss.bind.address.unsecure' value: ${localhost}"
		it.@value = '${jboss.bind.address.unsecure:' + "${localhost}" + "}"
	}
}

XmlUtil.serialize(xmlStandaloneFile, new FileWriter(standaloneFile))

