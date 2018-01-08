.. title: The Best Things that I have learned about Jenkins in 2017
.. slug: the-best-things-that-happened-in-jenkins-in-2017
.. date: 2018-01-07 16:47:15 UTC+01:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text

Past year I have spent internally within my team working on various CI/CD and Dev/Ops systems.
Sometimes Chef, sometimes Ansible, often Open Shift and everything mostly tied together with 
Jenkins. There were three of us representing  DEV, QE and OPS. We rebuilt our teams infrastructure from the ground up,
and lot of the interesting will probably stay hidden behind our VPN and in our private repos.

We tried to put as much as possible to public repositories, but all of the configuration, our keys and secrets,
and acompanying configuration scripts would stay hidden.

That is why I have decided to start writing down what we have learned. This year, our little tooling-team no longer exists,
but I hope this will make the knowledge more accessible and that I would need to spend less time reading through the Jenkins javadocs :-)

You can configure everything through groovy scripts
~~~~~~~~

This was probably the biggest advantage compared to our previous setups. All of the configuration is now in code.
In our previous Jenkins instance, the configuration was mostly ad-hoc, manual, often depending on specific configuration our slaves.
Changes to configuration was done with direct ssh to the slave through a shared account. Untangling the configuration was fun.

Now we use
* credentials-binding plugin to share our centrally stored secrets across our jobs
* config-file-provider to share the non-secret configuration
* plain-credentials and ssh-credentials to store the secrets centrally on the master Jenkins

The interesting thing here is automating the update of the credentials. Currently, we rely on combination of groovy scripts and
sh scripts running the jenkins-cli to run the groovy on Jenkins and so far it worked very well.

For example with this groovy file:

.. highlight:: groovy
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

you could create a new credential just by running

.. highlight:: bash
    jenkins-cli -remoting -s $url groovy script.groovy $ID $CREDENTIAL --username $user --password $password

Figuring out the groovy script can be tricky at times, but the upside is undeniable, and currently if we wanted to,
we could configure a new instance of Jenkins under 30 minutes, including provisioning.

Using Jenkinsfiles and groovy pipelines is awesome
~~~~~~~~

The ability to use Jenkinsfiles and groovy pipelines was one of the reasons we wanted to create new Jenkins infrastructure.
The old Jenkins wouldn't be able to run these and when we were deciding wether to try to update the old or build a new one,
we have decided to build a new one.

And pipelines did deliver. Groovy is much more flexible language than bash that we used previously for most of our automation.
We managed to automate most of our release process and large parts of our deployment process. We don't think we would have managed that without groovy,
as during the release process we need to process, build and tag over 60 repositories.

Another nice thing that emerged over the year is better support for groovy itself. Running pipelines should be resilient to things like shutdowns and restarts of Jenkins. Unfortunately this meant that for long time, you couldn't use standard groovy methods like collect or each, because the resulting code wouldn't be serializable, and you would need to use workaround with @NonCPS annotation.

Fortunately, since TODO, most of these work, making for a much nicer environment to programm in!

With Github Organization Folders you can create your own custom Travis
~~~~~~~~

Jenkins Job Builder is still useful
~~~~~~~~

We have invested a lot into Open Shift integration, but it probably isn't for everyone
~~~~~~~~
