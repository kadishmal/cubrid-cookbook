# cubrid_test Chef cookbook

This **cubrid_test** cookbook is created to test the parent **cubrid** cookbook.

## Requirements

**cubrid_test** cookbook depends on the following cookbooks.

- [cubrid](https://github.com/kadishmal/cubrid-cookbook) - the parent **cubrid** cookbook.
- [minitest-handler](https://github.com/btm/minitest-handler-cookbook) - the assertion library for Chef. 

## Environment

This cookbook uses [Test Kitchen](https://github.com/opscode/test-kitchen) to run tests on multiple Vagrant VMs in Ruby 1.9.2. Perform the following tests in order to prepare the environment.

### Install RVM

Test Kitchen requires Ruby 1.9.2 or higher. The best way to install different versions of Ruby on the same system is to use Ruby Version Manager like [RVM](https://rvm.io). This cookbook uses RVM.

To [install the stable version of RVM](https://rvm.io/rvm/install), run the following command.

	$ \curl -L https://get.rvm.io | bash -s stable

Once installed, change the directory to the root **cubrid** cookbook directory and set the Ruby to be used.

	$ cd cubrid-cookbook
	$ rvm use .
	Using /Users/user/.rvm/gems/ruby-1.9.2-p320 with gemset cubrid-cookbook

### Install Test Kitchen

To install Test Kitchen, run the following command in the same **cubrid** cookbook root directory.

	$ bundle install

`bundle` is a Ruby program which install the necessary dependencies specified in the `Gemfile`.

### Load required cookbooks

The parent **cubrid** and this **cubrid_test** cookbooks require other cookbooks. To manage cookbook dependecies we use [Berkshelf](http://berkshelf.com/). It is already installed in the previous step.

To tell Berkshelf to load all required cookbooks, run the following command.

	$ berks install

## Testing

Once the environment is ready, start Test Kitchen.

	$ kitchen test

This will start testing on multiple Vagrant VMs sequencially. If named Vagrant box is not available, it will be downloaded from the specified `box_url`. Refer to `.kitchen.yml` configuration file for details.

## Results

After the tests are complete, all assertions should pass.

	Finished tests in 0.319754s, 53.1659 tests/s, 53.1659 assertions/s.
	17 tests, 17 assertions, 0 failures, 0 errors, 0 skips

## License and Authors

Distributed under [MIT License](http://en.wikipedia.org/wiki/MIT_License).

- Esen Sagynov (<kadishmal@gmail.com>)