#!/bin/bash -e
# PostGIS Webmin Module Full Installer
# For use on a clean Ubuntu 18 or CentOS 8 installation.
# Usage:
# Cited, Inc.  2020

#Set application user and database name
APPUSER='pgis'
APPDB='postgisftw'

#Get hostname
HNAME=$(hostname -f)

#Set postgresql version and password (random)
PG_VER='12'
PG_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32);

DISTRO=$(grep -m 1 ID /etc/os-release | cut -f2 -d= | tr -d '"')
DISTRO_VER=$(grep VERSION_ID /etc/os-release | tr -d '"' | cut -f2 -d=)
WWW_USER='www-data'

#Install Webmin
function install_webmin(){

	if [ "${DISTRO}" == 'ubuntu' ]; then

	echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list
	wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -
	apt-get -y update
	apt-get -y install webmin

	elif [ "${DISTRO}" == 'centos' ]; then

cat >/etc/yum.repos.d/webmin.repo <<EOF
[Webmin]
name=Webmin Distribution Neutral
#baseurl=https://download.webmin.com/download/yum
mirrorlist=https://download.webmin.com/download/yum/mirrorlist
enabled=1
EOF
		
		rpm --import http://www.webmin.com/jcameron-key.asc
		dnf -y install webmin

	fi
}
#Download PostGIS Webmin Module
function download_postgis_module(){

	pushd /opt/

	unzip webmin_postgis-master.zip
	mv webmin_postgis-master postgis
	tar -czf /opt/postgis.wbm.gz postgis
		

	popd
  
}
#Download Certbot Webmin Module
function download_certbot_module(){
pushd /tmp/
	wget https://github.com/cited/Certbot-Webmin-Module/archive/master.zip
	unzip master.zip
	mv Certbot-Webmin-Module-master certbot
	tar -czf /opt/certbot.wbm.gz certbot
	rm -rf certbot master.zip
popd
}
#Install Apache HTTP Server
function install_apache(){
	if [ "${DISTRO}" == 'ubuntu' ]; then
		apt-get -y install apache2
	elif [ "${DISTRO}" == 'centos' ]; then
		yum -y install httpd
	fi
}


function dbd_pg(){
	if [ "${DISTRO}" == 'ubuntu' ]; then
		apt-get -y install libdbd-pg-perl
	elif [ "${DISTRO}" == 'centos' ]; then
		yum -y perl-DBD-Pg
	fi
}
#Install PostGIS Webmin Module
function install_postgis_module(){
pushd /opt/
        if [ "${DISTRO}" == 'ubuntu' ]; then
       	/usr/share/webmin/install-module.pl postgis.wbm.gz
        elif [ "${DISTRO}" == 'centos' ]; then
        /usr/libexec/webmin/install-module.pl postgis.wbm.gz
        fi
popd
        echo -e "PostGIS Module is now installed. Go to Servers > PostGIS to complete installation"
	
}
#Install Certbot Webmin Module
function install_certbot_module(){
pushd /opt/
	if [ "${DISTRO}" == 'ubuntu' ]; then
	/usr/share/webmin/install-module.pl certbot.wbm.gz
        elif [ "${DISTRO}" == 'centos' ]; then
        /usr/libexec/webmin/install-module.pl certbot.wbm.gz
        fi
popd
        echo -e "Certbot is now installed. Go to Servers > Certbot to complete installation"
}	
#Create certificate for use by postgres
function make_cert_key(){
  name=$1

  SSL_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32);
  if [ $(grep -m 1 -c "ssl ${name} pass" /root/auth.txt) -eq 0 ]; then
    echo "ssl ${name} pass: ${SSL_PASS}" >> /root/auth.txt
  else
    sed -i.save "s/ssl ${name} pass:.*/ssl ${name} pass: ${SSL_PASS}/" /root/auth.txt
  fi
  openssl genrsa -des3 -passout pass:${SSL_PASS} -out ${name}.key 2048
  openssl rsa -in ${name}.key -passin pass:${SSL_PASS} -out ${name}.key

  chmod 400 ${name}.key

  openssl req -new -key ${name}.key -days 3650 -out ${name}.crt -passin pass:${SSL_PASS} -x509 -subj "/C=CA/ST=Frankfurt/L=Frankfurt/O=${HNAME}/CN=${HNAME}/emailAddress=info@acugis.com"
}
#Install PostgreSQL
function install_postgresql_ubuntu(){
	RELEASE=$(lsb_release -cs)

	echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
	apt-get -y update
	apt-get -y install postgresql-${PG_VER} postgresql-client-${PG_VER} postgresql-contrib-${PG_VER} \
						python3-postgresql postgresql-plperl-${PG_VER} postgresql-plpython3-${PG_VER} \
						postgresql-pltcl-${PG_VER} postgresql-${PG_VER}-postgis-2.3 \
						odbc-postgresql libpostgresql-jdbc-java
	if [ ! -f /usr/lib/postgresql/${PG_VER}/bin/postgres ]; then
		echo "Error: Get PostgreSQL version"; exit 1;
	fi

	ln -sf /usr/lib/postgresql/${PG_VER}/bin/pg_config 	/usr/bin
	ln -sf /var/lib/postgresql/${PG_VER}/main/		 	/var/lib/postgresql
	ln -sf /var/lib/postgresql/${PG_VER}/backups		/var/lib/postgresql

	service postgresql start

#Set postgres Password
	if [ $(grep -m 1 -c 'pg pass' /root/auth.txt) -eq 0 ]; then
		sudo -u postgres psql 2>/dev/null -c "alter user postgres with password '${PG_PASS}'"
		echo "pg pass: ${PG_PASS}" >> /root/auth.txt
	fi

#Add Postgre variables to environment
	if [ $(grep -m 1 -c 'PGDATA' /etc/environment) -eq 0 ]; then
		cat >>/etc/environment <<CMD_EOF
export PGDATA=/var/lib/postgresql/${PG_VER}/main
CMD_EOF
	fi

#Config pg_hba.conf

	cat >/etc/postgresql/${PG_VER}/main/pg_hba.conf <<CMD_EOF
local	all all 							trust
host	all all 127.0.0.1	255.255.255.255	trust
host	all all 0.0.0.0/0					md5
host	all all ::1/128						md5
hostssl all all 127.0.0.1	255.255.255.255	md5
hostssl all all 0.0.0.0/0					md5
hostssl all all ::1/128						md5
CMD_EOF
	sed -i.save "s/.*listen_addresses.*/listen_addresses = '*'/" /etc/postgresql/${PG_VER}/main/postgresql.conf
	sed -i.save "s/.*ssl =.*/ssl = on/" /etc/postgresql/${PG_VER}/main/postgresql.conf

#Create Symlinks for Backward Compatibility from PostgreSQL 9 to PostgreSQL 8

	mkdir -p /var/lib/pgsql
	ln -sf /var/lib/postgresql/${PG_VER}/main /var/lib/pgsql
	ln -sf /var/lib/postgresql/${PG_VER}/backups /var/lib/pgsql

#Create SSL certificates for postgresql

	if [ ! -f /var/lib/postgresql/${PG_VER}/main/server.key -o ! -f /var/lib/postgresql/${PG_VER}/main/server.crt ]; then
		make_cert_key 'server'
    chown postgres.postgres server.key server.crt

		mv server.key server.crt /var/lib/postgresql/${PG_VER}/main
	fi

	service postgresql restart
}
#PostgreSQL on CentOS 8
function install_postgresql_centos(){
	#1. Install PostgreSQL repo
	PG_V2=$(echo ${PG_VER} | sed 's/\.//')
	if [ ! -f /etc/yum.repos.d/pgdg-redhat-all.repo ]; then
		rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
	fi

	#2. Disable CentOS repo for PostgreSQL
	if [ $(grep -m 1 -c 'exclude=postgresql' /etc/yum.repos.d/CentOS-Base.repo) -eq 0 ]; then
		sed -i.save '/\[base\]/a\exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo
		sed -i.save '/\[updates\]/a\exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo
	fi

	#3. Install PostgreSQL
	dnf install -y postgresql${PG_V2} postgresql${PG_V2}-devel postgresql${PG_V2}-server postgresql${PG_V2}-libs postgresql${PG_V2}-contrib postgresql${PG_V2}-plperl postgresql${PG_V2}-plpython postgresql${PG_V2}-pltcl postgresql${PG_V2}-odbc

	export PGDATA='/var/lib/pgsql/${PG_VER}/data'
	export PATH="${PATH}:/usr/pgsql-${PG_VER}/bin/"
	if [ $(grep -m 1 -c '/usr/pgsql-${PG_VER}/bin/' /etc/environment) -eq 0 ]; then
		echo "export PATH=${PATH}" >> /etc/environment
	fi

	if [ $(grep -m 1 -c 'PGDATA' /etc/environment) -eq 0 ]; then
		echo "export PGDATA=${PGDATA}" >> /etc/environment
	fi

	if [ ! -f /var/lib/pgsql/${PG_VER}/data/pg_hba.conf ]; then
		sudo -u postgres /usr/pgsql-${PG_VER}/bin/initdb -D /var/lib/pgsql/${PG_VER}/data
	fi

	systemctl start postgresql-${PG_VER}

	#5. Set postgres Password
	if [ $(grep -m 1 -c 'pg pass' /root/auth.txt) -eq 0 ]; then
		PG_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32);
		sudo -u postgres psql 2>/dev/null -c "alter user postgres with password '${PG_PASS}'"
		echo "pg pass: ${PG_PASS}" > /root/auth.txt
	fi

	#6. Configure ph_hba.conf
	cat >/var/lib/pgsql/${PG_VER}/data/pg_hba.conf <<CMD_EOF
local	all all 							trust
host	all all 127.0.0.1	255.255.255.255	md5
host	all all 0.0.0.0/0					md5
host	all all ::1/128						md5
hostssl all all 127.0.0.1	255.255.255.255	md5
hostssl all all 0.0.0.0/0					md5
hostssl all all ::1/128						md5
CMD_EOF
	sed -i.save "s/.*listen_addresses.*/listen_addresses = '*'/" /var/lib/pgsql/${PG_VER}/data/postgresql.conf
	sed -i.save "s/.*ssl =.*/ssl = on/" /var/lib/pgsql/${PG_VER}/data/postgresql.conf

	#10. Create Symlinks for Backward Compatibility from PostgreSQL 9 to PostgreSQL 8
	ln -sf /usr/pgsql-${PG_VER}/bin/pg_config /usr/bin
	ln -sf /var/lib/pgsql/${PG_VER}/data /var/lib/pgsql
	ln -sf /var/lib/pgsql/${PG_VER}/backups /var/lib/pgsql

	#create SSL certificates
	if [ ! -f /var/lib/pgsql/${PG_VER}/data/server.key -o ! -f /var/lib/pgsql/${PG_VER}/data/server.crt ]; then
		make_cert_key 'server'
    chown postgres.postgres server.key server.crt
		mv server.key server.crt /var/lib/pgsql/${PG_VER}/data
	fi

	systemctl restart postgresql-${PG_VER}
	systemctl enable postgresql-${PG_VER}
}
#Set up postgresql for Crunchy Data stuff
function crunchy_setup_pg(){

  if [ $DISTRO == 'ubuntu' ]; then
    apt-get install -y postgis python
  elif [ $DISTRO == 'centos' ]; then
    dnf install -y postgis30_${PG_VER} postgis30_${PG_VER}-utils postgis30_${PG_VER}-client python36
  fi

  sudo -u postgres createuser ${APPUSER} --superuser

  APPUSER_PG_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32);
  sudo -u postgres psql <<CMD_EOF
alter user ${APPUSER} with password '${APPUSER_PG_PASS}';
CREATE DATABASE ${APPDB} WITH OWNER = ${APPUSER} ENCODING = 'UTF8';
\connect ${APPDB};
CREATE EXTENSION postgis;
CMD_EOF

  echo "${APPUSER} PG pass: ${APPUSER_PG_PASS}" >> /root/auth.txt
}

#Load Natual Earth data for testing
function load_pg_data(){
  pushd /home/${APPUSER}
    wget -P/tmp/ https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip
    unzip /tmp/ne_50m_admin_0_countries.zip
    rm -f /tmp/ne_50m_admin_0_countries.zip

    for f in ne_50m_admin_0_countries.*; do
      mv $f countries.${f#*.}
    done
    chown ${APPUSER}:${APPUSER} countries.*

    shp2pgsql -I -s 4326 -W "latin1" countries.shp countries | sudo -u ${APPUSER} psql -d ${APPDB}

    rm -f countries.*
  popd
}

#Install pg_tileserv and config to run as a service
function install_pg_tileserv(){
  TILESERV_HOME='/opt/pg_tileserv'
  mkdir -p ${TILESERV_HOME}

  pushd ${TILESERV_HOME}
    wget -P/tmp https://postgisftw.s3.amazonaws.com/pg_tileserv_latest_linux.zip
    unzip /tmp/pg_tileserv_latest_linux.zip
    rm -f /tmp/pg_tileserv_latest_linux.zip

    pushd config
     	sed -i.save "s|# DbConnection = \"postgresql://username:password@host/dbname\"|DbConnection = \"postgresql://${APPUSER}:${APPUSER_PG_PASS}@localhost/${APPDB}\"|" pg_tileserv.toml.example
  	  sed -i.save "s|^AssetsPath =.*|AssetsPath = \"${TILESERV_HOME}/assets\"|g" pg_tileserv.toml.example
     	mv pg_tileserv.toml.example pg_tileserv.toml
    popd
  popd
  chown -R ${APPUSER}:${APPUSER} ${TILESERV_HOME}

#The service file
  cat >/etc/systemd/system/pg_tileserv.service <<CMD_EOF
[Unit]
Description=PG TileServ
After=multi-user.target

[Service]
User=${APPUSER}
WorkingDirectory=${TILESERV_HOME}
Type=simple
Restart=always
ExecStart=${TILESERV_HOME}/pg_tileserv --config ${TILESERV_HOME}/config/pg_tileserv.toml

[Install]
WantedBy=multi-user.target
CMD_EOF

  systemctl daemon-reload
  systemctl enable pg_tileserv
  systemctl start pg_tileserv
}

#Install pg_featureserv and config to run as a service
function install_pg_featureserv(){
  FEATSERV_HOME='/opt/pg_featureserv'
  mkdir -p ${FEATSERV_HOME}

  pushd ${FEATSERV_HOME}
    wget -P/tmp https://postgisftw.s3.amazonaws.com/pg_featureserv_latest_linux.zip
    unzip /tmp/pg_featureserv_latest_linux.zip
    rm -f /tmp/pg_featureserv_latest_linux.zip

    pushd config

      sed -i.save "s|# DbConnection = \"postgresql://username:password@host/dbname\"|DbConnection = \"postgresql://${APPUSER}:${APPUSER_PG_PASS}@localhost/${APPDB}\"|" pg_featureserv.toml.example
      sed -i.save "s|^AssetsPath =.*|AssetsPath = \"${FEATSERV_HOME}/assets\"|g" pg_featureserv.toml.example
      mv pg_featureserv.toml.example pg_featureserv.toml
    popd

  popd

  chown -R ${APPUSER}:${APPUSER} ${FEATSERV_HOME}

  cat >/etc/systemd/system/pg_featureserv.service <<CMD_EOF
[Unit]
Description=PG FeatureServ
After=multi-user.target

[Service]
User=${APPUSER}
WorkingDirectory=${FEATSERV_HOME}
Type=simple
Restart=always
ExecStart=${FEATSERV_HOME}/pg_featureserv --config ${FEATSERV_HOME}/config/pg_featureserv.toml

[Install]
WantedBy=multi-user.target
CMD_EOF


  systemctl daemon-reload
  systemctl enable pg_featureserv
  systemctl start pg_featureserv

}

#Display info for user
function info_for_user()
{
#End message for user
echo -e "Installation is now completed."
echo -e "Access pg-tileserv at ${HNAME}:7800"
echo -e "Access pg-featureserv at ${HNAME}:9000"
echo -e "postgres and crunchy pg passwords are saved in /root/auth.txt file"
}
#User set up
function setup_user(){
  useradd -m ${APPUSER}

  echo "${APPUSER}:${APPUSER}:${PG_PASS}" >/home/${APPUSER}/.pgpass
  chown ${APPUSER}:${APPUSER} /home/${APPUSER}/.pgpass
}
#Install bootstrap app
function install_bootstrap_app(){
  wget -P/tmp https://cdn.acugis.com/geohelm/docs.tar.bz2
  tar -x --overwrite -f /tmp/docs.tar.bz2 -C/var/www/html
  rm -f /tmp/docs.tar.bz2
}
#Install ol latest
function install_openlayers(){
  OL_VER=$(wget -q -L -O- https://github.com/openlayers/openlayers/releases/latest | sed -n 's/.*<title>Release v\([0-9\.]\+\).*/\1/p')

  wget -P/tmp "https://github.com/openlayers/openlayers/releases/download/v${OL_VER}/v${OL_VER}-dist.zip"

  unzip -u /tmp/v${OL_VER}-dist.zip
  mv v${OL_VER}-dist /var/www/html/OpenLayers
  rm -f /tmp/v${OL_VER}-dist.zip

  chown -R $WWW_USER:$WWW_USER /var/www/html/OpenLayers
}
#Install leaflet latest
function install_leafletjs(){
  LL_VER=$(wget -q -O- 'http://leafletjs.com/download.html' | sed -n 's/.*cdn\.leafletjs\.com\/leaflet\/v\([0-9\.]\+\)\/leaflet\.zip.*/\1/p' | sort -rn | head -1)

  wget -P/tmp "http://cdn.leafletjs.com/leaflet/v${LL_VER}/leaflet.zip"

  unzip /tmp/leaflet.zip -d /var/www/html/leafletjs
  rm -f /tmp/leaflet.zip
  chown -R $WWW_USER:$WWW_USER /var/www/html/leafletjs
}
#Ubuntu prerqs
function install_postgis_pkgs_ubuntu(){
  apt-get install -y postgis postgresql-${PG_VER}-pgrouting-scripts postgresql-${PG_VER}-pgrouting osm2pgsql osm2pgrouting
}
#Install osm2pgsql from source
function install_osm2pgsql_source(){

	wget -P/tmp https://github.com/openstreetmap/osm2pgsql/archive/master.zip
	unzip /tmp/master.zip
	rm -f /tmp/master.zip

	pushd osm2pgsql-master
		mkdir build
		pushd build
			cmake ..
			make
			make install
		popd
	popd
	rm -rf osm2pgsql-master
}
#Install osm2pgrouting from source
function install_osm2pgrouting_source(){
	wget -P/tmp https://github.com/pgRouting/osm2pgrouting/archive/master.zip
	unzip /tmp/master.zip
	rm -rf /tmp/master.zip

	pushd osm2pgrouting-master
		mkdir build
		pushd build
			cmake ../
			make
			make install
		popd
	popd
	rm -rf osm2pgrouting-master
}
#Install centos deps
function install_postgis_pkgs_centos(){
	#proj-epsg is missing in CentOS 8
	dnf install -y cmake make gcc-c++ boost-devel expat-devel zlib-devel \
  	bzip2-devel postgresql12-devel proj-devel lua-devel libpq-devel libpqxx-devel

  dnf install -y pgrouting_${PG_VER}

	#osm2pgsql is not available in CentOS 8
	install_osm2pgsql_source
	install_osm2pgrouting_source

	dnf remove -y cmake make gcc-c++ boost-devel expat-devel zlib-devel bzip2-devel \
	 	postgresql-devel proj-devel lua-devel libpq-devel libpqxx-devel
}

function remove_setup(){
  if [ "${DISTRO}" == 'ubuntu' ]; then
    rm -rf /usr/share/webmin/postgis/setup.cgi
  elif [ "${DISTRO}" == 'centos' ]; then
    rm -rf /usr/libexec/webmin/postgis/setup.cgi
  fi
}

touch /root/auth.txt

if [ "${DISTRO}" == 'ubuntu' ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-add-repository universe

  apt-get -y install wget unzip apache2 bzip2

elif [ "${DISTRO}" == 'centos' ]; then
  #Specific CentOS fixes
  dnf module disable -y postgresql
  sed -i.save 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-PowerTools.repo

  dnf -y install tar httpd wget unzip epel-release bzip2

  WWW_USER='apache'
fi

setup_user;


install_webmin;
install_apache;
download_postgis_module;
download_certbot_module;
install_certbot_module;
install_postgis_module;

install_postgresql_${DISTRO};
dbd_pg;
crunchy_setup_pg;
load_pg_data;

install_pg_tileserv;
install_pg_featureserv;

install_bootstrap_app;
install_openlayers;
install_leafletjs;

if [ "${DISTRO}" == 'ubuntu' ]; then
  install_postgis_pkgs_ubuntu
elif [ "${DISTRO}" == 'centos' ]; then
  install_postgis_pkgs_centos
fi

info_for_user;
remove_setup;
