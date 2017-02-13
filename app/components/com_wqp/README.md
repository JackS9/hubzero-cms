
Installation
============

Unzip and place the resulting directory into /app/components

The final result should look like:

    /app
    .. /components
    .. .. /com_wqp 
    .. .. .. /admin
    .. .. .. /api
    .. .. .. /config
    .. .. .. /helpers
    .. .. .. /models
    .. .. .. /site
    .. .. .. install.sql
    .. .. .. wqp.xml

The install.sql file contains SQL for creating the needed database tables and populating them
with sample data. This may be manually added to the database or installed via the "discover"
feature of the extensions manager:

Login to the administrator area. Go to "Extensions > Extensions Manager". Click the sub-menu
item "Discover". From that page, click "Discover" in the toolbar. If you see "WQP" show up
in the resulting list, click the checkbox next to it and click the "Install" button.
