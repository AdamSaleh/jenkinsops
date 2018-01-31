import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import org.jenkinsci.plugins.plaincredentials.impl.*
import hudson.util.Secret

def credId = args[0]
def description = args[1]
def secret = args[2]

def domain = Domain.global()
def store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

def secretText = new StringCredentialsImpl(CredentialsScope.GLOBAL,credId,description, Secret.fromString(secret))

store.addCredentials(domain, secretText)
