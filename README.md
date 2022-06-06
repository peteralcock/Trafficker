
![Trafficker](webui/src/images/trafficker.jpg?raw=true "Trafficker")

<hr>

Scalable requests routing, authentication, rate limiting, and usage metrics can be instantly applied to any new service <hr><br>


## Getting started
vagrant up

### Using Docker 

```shell

$ docker-compose up

```


### From Source 


```shell

# Initial Setup
apt-get -y update && apt-get -y upgrade
git clone http://github.com/eclecticLabs/Trafficker
cd Trafficker

pip install -r requirements.txt
sudo pip install forever -g
apt-get -y --force-yes install vim nginx python-dev \ 
python-flup python-pip python-ldap expect git memcached \ 
 sqlite3 libcairo2 libcairo2-dev python-cairo pkg-config nodejs npm

pip install django==1.5.12 \ 
 python-memcached==1.53 \ 
 django-tagging==0.3.1 \ 
 twisted==11.1.0 \ 
 txAMQP==0.6.2

# Graphite
git clone -b 0.9.15 --depth 1 https://github.com/graphite-project/graphite-web.git /usr/local/src/graphite-web
/usr/local/src/graphite-web
python ./setup.py install
cp conf/opt/graphite/conf/*.conf /opt/graphite/conf/
cp conf/opt/graphite/webapp/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py

# Whisper
git clone -b 0.9.15 --depth 1 https://github.com/graphite-project/whisper.git /usr/local/src/whisper
cd /usr/local/src/whisper
python ./setup.py install

# Carbon
git clone -b 0.9.15 --depth 1 https://github.com/graphite-project/carbon.git /usr/local/src/carbon
cd /usr/local/src/carbon
python ./setup.py install

# StatsD
git clone -b v0.7.2 https://github.com/etsy/statsd.git /opt/statsd
cp conf/opt/statsd/config.js /opt/statsd/config.js
forever start /opt/statsd/stats.js /opt/statsd/config.js

# nginx
rm /etc/nginx/sites-enabled/default
cp conf/etc/nginx/nginx.conf /etc/nginx/nginx.conf
cp conf/etc/nginx/sites-enabled/graphite-statsd.conf /etc/nginx/sites-enabled/graphite-statsd.conf

# Admin panel
cp conf/usr/local/bin/django_admin_init.exp /usr/local/bin/django_admin_init.exp
./usr/local/bin/django_admin_init.exp

# Logging
mkdir -p /var/log/carbon /var/log/graphite /var/log/nginx
cp conf/etc/logrotate.d/graphite-statsd /etc/logrotate.d/graphite-statsd

# Daemons
cp conf/etc/service/carbon/run /etc/service/carbon/run
cp conf/etc/service/carbon-aggregator/run /etc/service/carbon-aggregator/run
cp conf/etc/service/graphite/run /etc/service/graphite/run
cp conf/etc/service/statsd/run /etc/service/statsd/run
cp conf/etc/service/nginx/run /etc/service/nginx/run
cp conf /etc/graphite-statsd/conf
cp conf/etc/my_init.d/01_conf_init.sh /etc/my_init.d/01_conf_init.sh

# Analytics
cd /opt/dashboard
(sudo gem install bundler)
bundle install
dashing start -d

# Management GUI
cd /opt/webui
npm install
bin/dashboard.js build
forever start bin/dashboard.js start [-p 8080]

# Cleanup
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

```


## Usage

Manage your APIs using these endpoints:

<ul>
<li>Management GUI: http://localhost:8080</li>
<li>WebSocket Proxy: http://localhost:7999</li>
<li>API Endpoint: http://localhost:8000</li>
<li>Admin Endpoint: http://localhost:8001</li>
</ul>




# Slammer #

A collection of micro-services that allows developers to centralize authentication as a RESTful HTTP proxy into LDAP-compatible cloud/on-premises directory systems such as Microsoft Active Directory. It makes use of CAS for enterprise single sign-on, which is an open and well-documented authentication protocol. It also has a user sync application and a web-portal application which can heirarchy authenicated service chains, allowing for the use of multiple credential sources and types.

For more information, including instructions on LDAP, Active Directory, the CAS protocal, and setting up Slammer for getting all these things to play nicely with one another for the purposes of your applications, please <a href="https://github.com/eclecticlabs/slammer/wiki">visit the wiki</a>.
