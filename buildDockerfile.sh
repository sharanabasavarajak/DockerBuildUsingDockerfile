log() {
  echo -e "[`date`] : " $1
}

build_image() {
  log "INFO: Starting docker build of $1"
  /usr/bin/docker build --build-arg BASE_IMAGE_NAME=${BASE_IMAGE} -t ${BUILD_IMAGE} . --no-cache --force-rm
  if [ $? -ne "0" ]; then
    log "ERROR: Docker build failed"
	exit
  fi	
}

push_image() {
  log "INFO: login to docker registry"
  /usr/bin/docker login -u sharanabasavarajak -p $passwd
    if [ $? -ne "0" ]; then
      log "ERROR: Docker login failed"
	  exit
	else
       log "INFO: login to docker registry successful"
    fi	
	  log "INFO: Pushing image to docker registry"
	/usr/bin/docker tag ${BUILD_IMAGE} sharanabasavarajak/${BUILD_IMAGE}
    /usr/bin/docker push sharanabasavarajak/${BUILD_IMAGE}	
    if [ $? -ne "0" ]; then
      log "ERROR: Docker push failed"
	  exit
	else
       log "INFO: push to docker registry successful"
    fi	
}

if [ '$#' -eq 3 ]; then
  BASE_IMAGE=$1
  BUILD_IMAGE=$2
  passwd=$3
else
  BASE_IMAGE="jboss/base-jdk:11"
  BUILD_IMAGE="Wildfly"
fi 

build_image
push_image  
