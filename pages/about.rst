.. title: About
.. slug: about
.. date: 2018-02-25 08:32:06 UTC+01:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text

I have started to work on this site after a year I have been deep-diving into Jenkins configuration with three of my colleagues,
when we were rebuilding our CI/CD for our teams at Red Hat Mobile. We went from Jenkins on a single machine, with adhoc configuration,
to Jenkins on top of OpenrShift cluster with all of the configuration in code.

And because the configuration itself is secret, but at the same time it was probably the trickiest part to figure out,
with hour spent on figuring out groovy scripts, searching through stack-overflow, reading through Jenkins sources and experimenting,
I have decided to start writing this stuff down, so that I would live outside of our private repositories as well.

So with big thanks to Mike Nairn, Gerard Ryan and Paul McCarthy, I hope the snippets I collected here might save somebody few hours of their time.

Beware, we might have went little bit overboard with the groovy scripting!
