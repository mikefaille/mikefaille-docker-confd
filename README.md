confd
====

Manage local application configuration files using templates and data from etcd
A lightweight configuration management tool focused on: 

Sync configuration files by polling etcd and processing template resources.
Reloading applications to pick up new config file changes

Note : To had confd configs, you can build a new docker form this one. If you just want quick test, see nuagebec/ubuntu docker image to get builtin' ssh access https://github.com/cloudbec/nuagebec-docker-ubuntu


### Create a template resource config

Template resources are defined in [TOML](https://github.com/mojombo/toml) config files under the `confdir` conf.d directory (i.e. /etc/confd/conf.d/*.toml).

Create the following template resource config and save it as `/etc/confd/conf.d/myconfig.toml`.

```Text
[template]
src = "myconfig.conf.tmpl"
dest = "/tmp/myconfig.conf"
keys = [
  "/myapp/database/url",
  "/myapp/database/user",
]
```

### Create the source template

Source templates are plain old [Golang text templates](http://golang.org/pkg/text/template/#pkg-overview), and are stored under the `confdir` templates directory. Create the following source template and save it as `/etc/confd/templates/myconfig.conf.tmpl`

```
# This a comment
[myconfig]
database_url = {{ .myapp_database_url }}
database_user = {{ .myapp_database_user }}
```

### Processing template resources

confd supports two modes of operation, daemon and onetime mode. In daemon mode, confd runs in the foreground processing template resources every 5 mins by default. For this tutorial we are going to use onetime mode.

By default your etcd server is running at http://127.0.0.1:4001 you can run the following command to process the `/etc/confd/conf.d/myconfig.toml` template resource:

```
confd -verbose -onetime -node 'http://127.0.0.1:4001' -confdir /etc/confd
```
Output:
```
2013-11-03T18:00:47-08:00 confd[21294]: NOTICE Starting confd
2013-11-03T18:00:47-08:00 confd[21294]: NOTICE etcd nodes set to http://127.0.0.1:4001
2013-11-03T18:00:47-08:00 confd[21294]: INFO Target config /tmp/myconfig.conf out of sync
2013-11-03T18:00:47-08:00 confd[21294]: INFO Target config /tmp/myconfig.conf has been updated
```

The `dest` config should now be in sync with the template resource configuration.

```
cat /tmp/myconfig.conf
```

Output:
```
# This a comment
[myconfig]
database_url = db.example.com
database_user = rob
