
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
	[raster2pgsql](https://subscription.packtpub.com/book/big_data_and_business_intelligence/9781784391645/1/ch01lvl1sec7/loading-rasters-using-raster2pgsql)

Copyright
---------

* Copyright Cited, Inc, 2020
