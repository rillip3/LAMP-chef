Description
====

This is a template for deploying a standard LAMP server. By default, this
template will create a single Linux server and install Apache, PHP, and
MySQL (versions will vary based on the operating system chosen). This template
also include [Holland](http://hollandbackup.org/) (automated MySQL backups) and
[phpMyAdmin](http://phpmyadmin.net/). This template is leveraging 
[chef-solo](http://docs.opscode.com/chef_solo.html) to setup the server. 

Requirements
============
* A Heat provider that supports the Rackspace `OS::Heat::ChefSolo` plugin.
* An OpenStack username, password, and tenant id.
* [python-heatclient](https://github.com/openstack/python-heatclient)
`>= v0.2.8`:

```bash
pip install python-heatclient
```

We recommend installing the client within a [Python virtual
environment](http://www.virtualenv.org/).

Example Usage
=============
Here is an example of how to deploy this template using the
[python-heatclient](https://github.com/openstack/python-heatclient):

```
heat --os-username <OS-USERNAME> --os-password <OS-PASSWORD> --os-tenant-id \
  <TENANT-ID> --os-auth-url https://identity.api.rackspacecloud.com/v2.0/ \
  stack-create LAMP -f heat-lamp.yaml -P server_hostname=my-site
```

* For UK customers, use `https://lon.identity.api.rackspacecloud.com/v2.0/` as
the `--os-auth-url`.

Optionally, set environmental variables to avoid needing to provide these
values every time a call is made:

```
export OS_USERNAME=<USERNAME>
export OS_PASSWORD=<PASSWORD>
export OS_TENANT_ID=<TENANT-ID>
export OS_AUTH_URL=<AUTH-URL>
```

Parameters
==========
Parameters can be replaced with your own values when standing up a stack. Use
the `-P` flag to specify a custom parameter.

* `server_hostname`: Sets the hostname for the node
* `phpmyadmin_user`: Username for the phpMyAdmin login (Default: serverinfo)
* `image`: Operating system to install on all systems (Default: Ubuntu 12.04
  LTS (Precise Pangolin))
* `flavor`: Cloud server size to use with the database server 
  (Default: 1 GB Performance)

Outputs
=======
Once a stack comes online, use `heat output-list` to see all available outputs.
Use `heat output-show <OUTPUT NAME>` to get the value fo a specific output.

* `private_key`: SSH private that can be used to login as root to the server.
* `server_ip`: Public IP address of the server
* `phpmyadmin_user`: Username for the /phpMyAdmin login
* `phpmyadmin_pass`: Password for the /phpMyAdmin login
* `mysql_root_password`: Root password for MySQL

For multi-line values, the response will come in an escaped form. To get rid of
the escapes, use `echo -e '<STRING>' > file.txt`. For vim users, a substitution
can be done within a file using `%s/\\n/\r/g`.

Stack Details
=============
[Apache](http://www.apache.org/) v2.2 is installed on all Red Hat
Enterprise Linux and Ubuntu distributions.

[MySQL](http://www.mysql.com/) v5.5 is installed on Ubuntu 12.04, 14.04,
Red Hat Enterprise Linux 6.5 and CentOS v6.5. MySQL v5.1 is installed on
Ubuntu 10.04. The MySQL root password is recorded in root's home directory
in the file .my.cnf and in the password section of this deployment. Daily
database backups are taken using [Holland](http://hollandbackup.org/). A
rotating seven days of database dumps are stored in /var/lib/mysqlbackup.

[PHP](http://www.php.net/) is installed at v5.3 on Ubuntu 12.04, v5.5 on
Ubuntu 14.04 and v5.4 on Red Hat Enterprise Linux and CentOS.

[phpMyAdmin](http://www.phpmyadmin.net/) is available via HTTP at
/phpmyadmin. Apache is configured to require HTTP basic authentication.
Log in as the user specified when deploying (the default is `serverinfo`)
with the password displayed in the password section of this deployment.
You may then login using MySQL login credentials which are also available
in the password section of this deployment.

Contributing
============
There are substantial changes still happening within the [OpenStack
Heat](https://wiki.openstack.org/wiki/Heat) project. Template contribution
guidelines will be drafted in the near future.

License
=======
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

