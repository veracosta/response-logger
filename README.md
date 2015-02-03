response-logger
===============
Updated: Nov 5, 2014

Record response time of application into logfile.

You need "Ruby" and "Nagios Plugins" to run response-logger.

Following protocols are currently supported.  
* http  
* dns

Usage
---------------------------------
Run the script as follows.

`ruby response-logger.rb example.com`

You can change the interval time to run Nagios Plugin by adding time after the target hostname.

`ruby response-logger.rb example.com 5`
