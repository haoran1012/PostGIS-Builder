.. _jri-label:
.. This is a comment. Note how any initial comments are moved by
   transforms to after the document title, subtitle, and docinfo.

.. demo.rst from: http://docutils.sourceforge.net/docs/user/rst/demo.txt

.. |EXAMPLE| image:: static/yi_jing_01_chien.jpg
   :width: 1em

**********************
Varnish
**********************

.. contents:: Table of Contents


About
=================

Varnish Cache is an HTTP accelerator.

By caching output, you reduce calls the the database and speed site performance.

Varnish Cache website:  https://varnish-cache.org
   
   

Usage
=================

The most common function is clearing Cache after changes are made.

To clear cache, click the Clear Cache button as show below:

.. image:: _static/varnish-clear-cache.png

If Varnished has stopped for any reason, a Start button will appear as below:

.. image:: _static/varnish-start.png

You can also stop/start/restart Varnish via command line::

  service varnish stop | stop | restart | status
   

Configuration
=============

The main varnish configuration file, default.vcl is located at::

	/etc/varnish/default.vcl
		
The content will look similar to below

.. code-block:: console
   :linenos:
		vcl 4.0;

		backend default {
    		.host = "127.0.0.1";
    		.port = "8080";
		}
		
Note the backend port, which is the port that Apache is on.

Similarly, Varnish itself is run on port 80.  This is defined in the varnish.service file located at::

/etc/systemd/system/varnish.service.d/varnish.conf

The contents of varnish.conf are as below.

Not that Varnish is accepting requests on 80 and proxy HTTPS requests to 8443

.. code-block:: console
   :linenos:

		[Service]
		ExecStart=
		ExecStart=/usr/sbin/varnishd -j unix,user=vcache -F -a :80 -a localhost:8443,PROXY -p feature=+http2 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s malloc,1g
		


Content
=========

The content of the html page is displayed below.

.. code-block:: console
   :linenos:

	<!doctype html>
	<html>
	<head>
  	<style type="text/css">
    	body {
      	padding: 0;
      	margin: 0;
    	}

    	html, body, #map {
      	height: 100%;
    	}

  	</style>

	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.1.0/dist/leaflet.css"
   	integrity="sha512-wcw6ts8Anuw10Mzh9Ytw4pylW8+NAD4ch3lqm9lzAsTxg0GFeJgoAtxuCLREZSC5lUXdVyo/7yfsqFjQ4S+aKw=="
   	crossorigin=""/>

    	<script src="https://unpkg.com/leaflet@1.1.0/dist/leaflet.js"
   	integrity="sha512-mNqn2Wg7tSToJhvHcqfzLMU6J4mkOImSPTxVZAdo+lcPlk+GhZmYgACEe0x35K7YzW1zJ7XyJV/TT1MrdXvMcA=="
   	crossorigin=""></script>
  	</head> 
  
	<script src="http://code.jquery.com/jquery-2.1.0.min.js"></script>
	</head>
	<body>
  	<div id="map"></div>
  	<script>
	var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  	var osmAttrib='Data &copy <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
  	var osm = new L.TileLayer(osmUrl, {minZoom: 2, maxZoom: 8, attribution: osmAttrib});
    
    	$.getJSON("states.geojson", function(data) {
	function onEachFeature(feature, layer) {
        layer.bindPopup("Name: " + feature.properties.STATE_NAME + "<br>" + "Abbreviation: " + feature.properties.STATE_ABBR);
  	}   
	var geojson = L.geoJson(data, {
      	onEachFeature: onEachFeature
    	});
	
    	var map = L.map('map').fitBounds(geojson.getBounds());
    	osm.addTo(map);
    	geojson.addTo(map);
  	});
	  </script>
	</body>
	</html>


Documentation
==============
https://leafletjs.com/

https://leafletjs.com/examples/geojson/
   
