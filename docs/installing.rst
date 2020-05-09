************
Installation
************

Installation can be done using the postgis-builder.sh script or via GIT.

Using the Installer
=======================

On a fresh CentOS 8, Ubuntu 18, or Ubuntu 20 installation, the fastest method is to use the postgis-builder.sh script:

.. code-block:: console
   :linenos:
   
   wget https://raw.githubusercontent.com/AcuGIS/PostGIS-Builder/master/scripts/postgis-builder.sh
   chmod +x postgis-builder.sh
   ./postgis-builder.sh
    
The above will install all of the components.

If you do not wish to install Webmin and the PostGIS Webmin Module, comment out the lines below.

.. code-block:: console
   :linenos:

   # install_webmin
   # install_postgis_module
   # install_certbot_module

When the script completes, you will see the message below containg the urls and password.

The passwords are also stored in the file /root/auth.txt following set up

.. code-block:: console
   :linenos:

   ~
   PostGIS Builder is now installed. 


Via Git or Download
===================

You can use Git to build module for an existing Webmin installation:

.. code-block:: console
   :linenos:

    git clone https://github.com/AcuGIS/PostGIS-Builder
    mv PostGIS-Builder-master postgis
    tar -cvzf postgis.wbm.gz postgis/

    
.. note::
    Following above, you will need to log in to Webmin to complete installation using the install :ref:`wizard-label`.   
    


