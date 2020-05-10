.. _jri-label:
.. This is a comment. Note how any initial comments are moved by
   transforms to after the document title, subtitle, and docinfo.

.. demo.rst from: http://docutils.sourceforge.net/docs/user/rst/demo.txt

.. |EXAMPLE| image:: static/yi_jing_01_chien.jpg
   :width: 1em

**********************
Leaflet GeoJson
**********************

.. contents:: Table of Contents


Access
=================

A web application employing LeafletJS and GeoJson is enabled upon installation.

It can be access via the Leaflet tab on the home page:

.. image:: _static/leaflet-tab.png

It can also be access directly via url at::

   http://domain.com/LeafletJSDemo.html.html
   
   

Usage
=================

Once accessed using above, the app will appear as shown below:

.. image:: _static/leaflet-app1.png

Click anywhere to select a start location, then click elswhere for an end location.

The route will be displayed as below:

.. image:: _static/leaflet-app2.png
   

Structure
=============

The app is located at::

	/vaw/www/html/pgrouting-openlayers.html
	
On installation, the pg_tileserv and pg_featureserv urls are set in the html document::

	...
	var vectorUrl = "http://206.189.186.146:7800/public.ways/{z}/{x}/{y}.pbf";
	...
    	var url = "http://206.189.186.146:9000/functions/boston_find_route/items.json";
	...



Documentation
==============
https://openlayers.org

https://pgrouting.org/

https://github.com/crunchydata/pg_tileserv

https://github.com/crunchydata/pg_featureserv<br>

   
