.. _jri-label:
.. This is a comment. Note how any initial comments are moved by
   transforms to after the document title, subtitle, and docinfo.

.. demo.rst from: http://docutils.sourceforge.net/docs/user/rst/demo.txt

.. |EXAMPLE| image:: static/yi_jing_01_chien.jpg
   :width: 1em

**********************
GeoDjango
**********************

.. contents:: Table of Contents

=================
GeoDjango App
=================

A basic GeoDjango app usign PostGIS is created upon installation.

It can be access via the GeoDjango tab on the home page:

.. image:: _static/postgresql-tab.png

It can also be access directly via url at::

   http://domain.com:4000
   
=============
Structure
=============

The GeoDjango app is located under /opt/geodjango.

It has the following structure:

.. code-block:: bash
   :linenos:

	/opt/geodjango
	└── world
    	├── manage.py
    	├── media
    	├── states
    	│   ├── __init__.py
    	│   ├── __pycache__
    	│   │   ├── __init__.cpython-36.pyc
    	│   │   ├── admin.cpython-36.pyc
    	│   │   ├── load.cpython-36.pyc
    	│   │   ├── models.cpython-36.pyc
    	│   │   ├── urls.cpython-36.pyc
    	│   │   └── views.cpython-36.pyc
    	│   ├── admin.py
    	│   ├── apps.py
    	│   ├── data
    	│   │   ├── states.dbf
    	│   │   ├── states.prj
    	│   │   ├── states.sbn
    	│   │   ├── states.sbx
    	│   │   ├── states.shp
    	│   │   ├── states.shp.xml
    	│   │   └── states.shx
    	│   ├── migrations
    	│   │   ├── 0001_initial.py
    	│   │   ├── __init__.py
    	│   │   └── __pycache__
    	│   │       ├── 0001_initial.cpython-36.pyc
    	│   │       └── __init__.cpython-36.pyc
    	│   ├── models.py
    	│   ├── support
    	│   │   ├── geodjango.apache
    	│   │   └── load.py
    	│   ├── templates
    	│   │   └── states
    	│   │       ├── state-detail.html
    	│   │       └── states-index.html
    	│   ├── tests.py
    	│   ├── urls.py
    	│   └── views.py
    	├── static
    	│   ├── admin
    	│   │   ├── css
    	│   │   │   ├── autocomplete.css
    	│   │   │   ├── base.css
    	│   │   │   ├── changelists.css
    	│   │   │   ├── dashboard.css
    	│   │   │   ├── fonts.css
    	│   │   │   ├── forms.css
    	│   │   │   ├── login.css
    	│   │   │   ├── responsive.css
    	│   │   │   ├── responsive_rtl.css
    	│   │   │   ├── rtl.css
    	│   │   │   ├── vendor
    	│   │   │   │   └── select2
    	│   │   │   │       ├── LICENSE-SELECT2.md
   	│   │   │   │       ├── select2.css
    	│   │   │   │       └── select2.min.css
    	│   │   │   └── widgets.css
    	│   │   ├── fonts
        │   │   ├── img
    	│   │   │   ├── LICENSE
    	│   │   │   ├── README.txt
    	│   │   │   ├── calendar-icons.svg
    	│   │   │   ├── gis
    	│   │   │   │   ├── move_vertex_off.svg
    	│   │   │   │   └── move_vertex_on.svg
   	    │   │   └── js
    	│   │       ├── SelectBox.js
    	│   │       ├── SelectFilter2.js
    	│   │       ├── actions.js
    	│   │       ├── actions.min.js
    	│   │       ├── admin
    	│   │       │   ├── DateTimeShortcuts.js
    	│   │       │   └── RelatedObjectLookups.js
    	│   │       ├── autocomplete.js
    	│   │       ├── calendar.js
    	│   │       ├── cancel.js
    	│   │       ├── change_form.js
    	│   │       ├── collapse.js
    	│   │       ├── collapse.min.js
    	│   │       ├── core.js
    	│   │       ├── inlines.js
    	│   │       ├── inlines.min.js
    	│   │       ├── jquery.init.js
    	│   │       ├── popup_response.js
    	│   │       ├── prepopulate.js
    	│   │       ├── prepopulate.min.js
    	│   │       ├── prepopulate_init.js
    	│   │       ├── urlify.js
    	│   │       └── vendor
    	│   │           ├── jquery
    	│   │           │   ├── LICENSE.txt
    	│   │           │   ├── jquery.js
    	│   │           │   └── jquery.min.js
    	│   │           ├── select2
    	│   │           │   ├── LICENSE.md
    	│   │           │   ├── i18n
    
    	│   │           │   ├── select2.full.js
    	│   │           │   └── select2.full.min.js
    	│   │           └── xregexp
    	│   │               ├── LICENSE.txt
    	│   │               ├── xregexp.js
    	│   │               └── xregexp.min.js
    	│   ├── gis
    	│   │   ├── css
    	│   │   │   └── ol3.css
    	│   │   ├── img
    	│   │   │   ├── draw_line_off.svg
    	│   │   │   ├── draw_line_on.svg
    	│   │   │   ├── draw_point_off.svg
    	│   │   │   ├── draw_point_on.svg
   	│   │   │   ├── draw_polygon_off.svg
    	│   │   │   └── draw_polygon_on.svg
    	│   │   └── js
    	│   │       └── OLMapWidget.js
    	│   └── leaflet
    	│       ├── Control.MiniMap.css
    	│       ├── Control.MiniMap.js
    	│       ├── draw
    	│       │   ├── images
    	│       │   │   ├── layers-2x.png
    	│       │   │   ├── layers.png
    	│       │   │   ├── marker-icon-2x.png
    	│       │   │   ├── marker-icon.png
    	│       │   │   ├── marker-shadow.png
    	│       │   │   ├── spritesheet-2x.png
    	│       │   │   ├── spritesheet.png
    	│       │   │   └── spritesheet.svg
    	│       │   ├── leaflet.draw-src.css
    	│       │   ├── leaflet.draw-src.js
    	│       │   ├── leaflet.draw.css
    	│       │   └── leaflet.draw.js
    	│       ├── eventlistener.ie6-7.js
    	│       ├── eventlistener.ie8.js
    	│       ├── images
    	│       │   ├── layers-2x.png
    	│       │   ├── layers.png
    	│       │   ├── marker-icon-2x.png
    	│       │   ├── marker-icon.png
    	│       │   ├── marker-icon@2x.png
    	│       │   ├── marker-shadow.png
    	│       │   ├── reset-view.png
    	│       │   ├── toggle.png
    	│       │   ├── zoom-in.png
    	│       │   └── zoom-out.png
    	│       ├── leaflet-src.js
    	│       ├── leaflet.css
    	│       ├── leaflet.extras.js
    	│       ├── leaflet.forms.js
    	│       ├── leaflet.ie.css
    	│       ├── leaflet.js
    	│       ├── proj4js.js
    	│       └── proj4leaflet.js
    	└── world
        	├── __pycache__
        	│   ├── settings.cpython-36.pyc
        	│   └── urls.cpython-36.pyc
        	├── asgi.py
        	├── settings.py
        	├── settings.py.save
        	├── urls.py
        	└── wsgi.py



.. image:: _static/postgresql-tab.png

You can also use the manager to install and update packages as well.

As certain packages require EPEL for CentOS, the EPEL repository is installed as well when installing on CentOS.

.. image:: _static/PostgreSQL-Repo-Manager.png

File Locations
==============

On CentOS, the PostgreSQL config direcotry is located at::

   /var/lib/pgsql/12/data
   
On Ubuntu, the PostgreSQL direcotry is located at::
   
   /etc/postgresql/12/main
   
The pg_hba.conf File
====================

On installation via the Wizard, PostgreSQL is configured for use with SSL and uses md5 authentication for all users and databases.

.. code-block:: bash
   :linenos:
   
   	local	all all 							trust
   	host	all all 127.0.0.1	255.255.255.255	md5
	host	all all 0.0.0.0/0					md5
	host	all all ::1/128						md5
	hostssl all all 127.0.0.1	255.255.255.255	md5
	hostssl all all 0.0.0.0/0					md5
	hostssl all all ::1/128						md5



The postgresql.conf File
========================

On installation via the Wizard, PostgreSQL is configured to accept connections on all interfaces as well as SSL connections.

.. code-block:: bash
   :linenos:

	#------------------------------------------------------------------------------
	# CONNECTIONS AND AUTHENTICATION
	#------------------------------------------------------------------------------

	# - Connection Settings -
	
	listen_addresses = '*'
	)
	
	
	# - SSL -

	ssl = on
   
Above are excepts.

Version
=======

GeoHelm has been tested with PostgreSQL 10, 11 and 12.

Webmin PostgreSQL Module
========================

On installation, the native PostgreSQL Database Server module is also activated.

It is located under Servers > PostgreSQL Database Server

.. image:: _static/webmin-postgresql.png



