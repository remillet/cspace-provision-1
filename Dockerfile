FROM cspace-version-3.3
MAINTAINER Richard Millet "richard.millet@berkeley.edu"

#
# Setup CollectionSpace instance-specific database properties
#
ENV DB_USER postgres
ENV DB_PASSWORD postgres
ENV DB_PASSWORD_NUXEO nuxeo
ENV DB_PASSWORD_CSPACE cspace

#
# Perform a full source code build and deployment. NOTE: We must build the Application layer first since it creates the configuation tool
# need to create the Service layer's configuration artifacts -i.e, things like the Nuxeo plugins and service bindings.
#
RUN cd $HOME/$CSPACE_USERNAME/src/ui && mvn clean install -DskipTests
RUN cd $HOME/$CSPACE_USERNAME/src/application && mvn clean install -DskipTests
RUN cd $HOME/$CSPACE_USERNAME/src/services && mvn clean install -DskipTests

#
# Deploy configuration artifacts, create and initialize the databases, and populate with AuthN/AuthZ tables
#
RUN cd $HOME/$CSPACE_USERNAME/src/services && ant undeploy deploy create_db import
