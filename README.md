
# PostGIS Webmin Module

[![Documentation Status](https://readthedocs.org/projects/postgis-webmin-module/badge/?version=latest)](https://postgis-webmin-module.readthedocs.io/en/latest/?badge=latest)



# Info
PostGIS Module for Webmin.  Install and Manage PostGIS, along with PgRouting, shp2pgsql, osm2pgsql, and raster2pgsql.

# Operating Systems
Ubuntu 18
Ububtu 20
CentOS 8

# Systems Requirements
5 GB SSD
1 GB RAM (Ubuntu)
2 GB RAM (CentOS - required for osm2pgsql build)

# Install via script:

      wget https://raw.githubusercontent.com/acugis/Postgis-Webmin-Module/master/scripts/postgis-install.sh
      chmod +x pre-install.sh
      ./postgis-install.sh

Go to Servers->PostGIS

# Install from GIT
Archive module

$ git clone https://github.com/acugis/Postgis-Webmin-Module/

$ mv Postgis-Webmin-Module postgis

$ tar -cvzf postgis.wbm.gz postgis/

Upload from Webmin->Webmin Configuration->Webmin Modules

Go to Servers->Postgis and complete the installtion Wizard.

# Notes

## **Ubuntu**
Ubuntu 18 and 20 LTS

## **Readhat/Fedora/CentOS**
CentOS 8

## **CentOS Notes**
CentOS requires 2 GB RAM for osm2pgsql build

# Screen Shot

PostGIS Module:

![POstGIS](docs/_static/postgis.png)

# Notes
	- pg_tileserv is on port 7800
	- pg_featureserv is n port 9000

# Links
[module](https://postgis-module.docs.acugis.com)<br>
[postgis](https://postgis.net/documentation/)<br>
[pgrouting](http://docs.pgrouting.org/)<br>
[osm2pgsql](https://github.com/openstreetmap/osm2pgsql/blob/master/docs/usage.md)<br>
[raster2pgsql](http://postgis.refractions.net/docs/using_raster.xml.html)<br>
[pg_tileserv](https://github.com/CrunchyData/pg_tileserv)<br>
[pg_featureserv](https://github.com/CrunchyData/pg_featureserv)<br>
[gdal](https://gdal.org/)<br>

Note: You can add docs and other links via /postgis/docs.cgi

Copyright
---------

* Copyright Cited, Inc, 2020
