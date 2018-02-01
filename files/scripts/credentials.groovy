import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*

def credId = args[0]
def description = args[1]
def username = args[2]
def password = args[3]

def store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
def secret = new UsernamePasswordCredentialsImpl(
      CredentialsScope.GLOBAL,
      credId,
      description,
      username,
      password
      )
store.addCredentials(Domain.global(), secret)
