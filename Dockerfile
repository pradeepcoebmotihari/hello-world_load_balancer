# Pull base image 
From tomcat:8-jre8
EXPOSE 8080

# Maintainer 
MAINTAINER "valaxytech@gmail.com" 
COPY webapp/target/webapp.war /usr/local/tomcat/webapps

