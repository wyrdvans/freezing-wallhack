# Project freezing-wallhack

This repo contains my solution to a task outlined in the [devops_project.html](devops_project.html) file of the repo.

## Pre Task Requirements

### rbenv
Use rbenv to avoid polluting the system ruby with any gems installed.

1. Follow the instructions in the github repo: [Basic github checkout](https://github.com/sstephenson/rbenv#basic-github-checkout)
* Install rbenv ruby-build plugin in order to install another ruby: [Recommended rbenv plugin install](https://github.com/sstephenson/ruby-build#installing-as-an-rbenv-plugin-recommended)
* Install the latest ruby version using the plugin:
		
		rbenv install 2.0.0-p451
		rbenv global 2.0.0-p451
	
### bundler gem
The bundler gem installs the bundle utility which allows you to install dependencies defined in a GemFile.

	gem install bundler	
	
Once bundler is installed, run it to install the needed gems:

	bundle install
	
### Vagrant
Download and install the latest version for your system from the [Vagrant download page](http://www.vagrantup.com/downloads.html).

Once Vagrant is installed, install plugins with the following:

	vagrant plugin install vagrant-omnibus
	vagrant plugin install vagrant-berkshelf

### Virtualbox
Download and install the latest version for your system from the [Virtualbox download page](https://www.virtualbox.org/wiki/Downloads).

## Task (Part 1)
Bring up the logstash vm by running `vagrant up`.

Once the vm is up and provisioned successfully, you can login to the vm by running `vagrant ssh`.

Access the kibana interface by browsing on your local machine to [http://localhost:8080](http://127.0.0.1:8080).

## Task (Part 2)
Using ruby TDD methods, a new pattern file, [patterns/haproxycustom](patterns/haproxycustom), was created in the patterns directory. 

In order to run the tests, first update the submodules to get the built in patterns from the logstash code. The tests require them.

The tests are defined in [spec/haproxycustom_spec.rb](spec/haproxycustom_spec.rb). To run the tests, execute the `rspec` command in the repo root. 

**TODO:**

- Create the appid, action and query string patterns.
- URL-decode the query string using the [urldecode filter](http://logstash.net/docs/1.3.3/filters/urldecode).
- Install the tested pattern file into the vm using chef.

## Task (Part 3)

**TODO:**

* Explain why RabbitMQ or redis seem to be the best choice.
* Touch on memory usage of agent and the pros of using a different agent.

# Deliverables
1. The [Berksfile](Berksfile) and [Vagrantfile](Vagrantfile) are the two files needed to provision a server with logstash, elasticsearch and kibana.

   The [Berksfile](Berksfile) contains the chef cookbook dependencies needed for bringing up a logstash server. 

   The [Vagrantfile](Vagrantfile) contains the vm instance configuration data to successfully provision a vm with the needed services.


# Timeline
This section tracks the time taken to develop the required sections.

**Project Setup**: *30 mins* This entails setting up the repo and organizing the way to communicate the solution.
	
**Pre-Task Requirements**: *~ 1 hr* This covers the setup required to test and interact with the solution. 

**Task (Part 1)**: *~ 5 hrs* A lot of this time was spent waiting for the vm to spinup while getting the cookbooks working in the Vagrantfile. The machine used to develop this solution lacked the processing power and disk I/O bandwidth for developing using VMs.

* Possible solution for scalability: http://devblog.springest.com/complete-logstash-stack-on-aws-opsworks-in-15-minutes/
* More work could be done to run elasticsearch and kibana on their own servers. The logstash cookbook sets up an embedded elasticsearch server but only recommends using it for testing purposes.

**Task (Part 2)**: *~ 6 hrs* This time was spent learning about the way logstash filters and parses the logs. Evaluating whether the HAPROXYHTTP grok pattern could be reused for the defined task took much longer than using it to write a new pattern.

**Task (Part 3)**: *~ 2 hrs* This time was spent looking at the various ways to send logs to logstash and looking for pros and cons regarding them.