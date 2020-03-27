#!/usr/bin/env python
# coding: utf-8

# In[11]:


import psycopg2


# In[12]:


conn = psycopg2.connect("dbname=suppliers user=postgres password=ankur715")


# In[13]:


conn = psycopg2.connect(host="localhost", database="suppliers", user="postgres", password="ankur715")


# The following is the list of the connection parameters:  
# 
# - database: the name of the database that you want to connect.  
# - user: the username used to authenticate.  
# - password: password used to authenticate.  
# - host: database server address e.g., localhost or an IP address.  
# - port: the port number that defaults to 5432 if it is not provided.

# The following config() function read the __database.ini__ file and returns the connection parameters. 
# 
# We put the __config()__ function in the __config.py__ file:

# In[15]:


#!/usr/bin/python
from configparser import ConfigParser
 
def config(filename='database.ini', section='postgresql'):
    # create a parser
    parser = ConfigParser()
    # read config file
    parser.read(filename)
 
    # get section, default to postgresql
    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))
 
    return db

