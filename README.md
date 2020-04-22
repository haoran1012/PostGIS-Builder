
# PostGIS Webmin Module

[![Documentation Status](https://readthedocs.org/projects/nagios-webmin-module/badge/?version=latest)](https://nagios-module.citedcorp.com/en/latest/?badge=latest)



# Info
PostGIS Module for Webmin.  Install and Manage Nagios Core and nrpe.

# Install via script:

      wget https://raw.githubusercontent.com/acugis/Postgis-Webmin-Module/master/scripts/pre-install.sh
      chmod +x pre-install.sh
      ./pre-install.sh

Go to Servers->PostGIS and complete the installtion Wizard.

# Install from GIT
Archive module

$ git clone https://github.com/acugis/Postgis-Webmin-Module/

$ mv Postgis-Webmin-Module postgis

$ tar -cvzf postgis.wbm.gz postgis/

Upload from Webmin->Webmin Configuration->Webmin Modules

Go to Servers->Postgis and complete the installtion Wizard.

# Notes

## **Ubuntu**
Tested on Ubuntu 18

## **Readhat/Fedora/CentOS**
Tested on CentOS 7x64

## **Issues**
Please report issue here

# Screen Shot

Nagios Module:

![POstGIS](docs/_static/postgis.png)

# Notes
	- pg_tileserv is on port 7800
	- pg_featureserv is n port 9000

# Links
Module:         https://postgis-module.docs.acugis.com<br>
PostGIS:        https://postgis.net/documentation/<br>
PgRouting:      http://docs.pgrouting.org/<br>
osm2pgsql:      https://github.com/openstreetmap/osm2pgsql/blob/master/docs/usage.md<br>
raster2pgsql:   http://postgis.refractions.net/docs/using_raster.xml.html<br>
pg_tileserve:   https://github.com/CrunchyData/pg_tileserv<br>
pg_featureserv: https://github.com/CrunchyData/pg_featureserv<br>
GDAL:           https://gdal.org/<br>

Note: You can add docs and other links via /postgis/docs.cgi

Copyright
---------

* Copyright Cited, Inc, 2020
