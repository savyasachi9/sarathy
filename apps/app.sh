# This func is a wrapper for 'task' cmd to make things simpler for the end user like
# task -t FILE_PATH/taskfile.yaml cmd -> app name cmd
# eg: app mysql test
app(){
  #SARATHY_HOME=${SARATHY_HOME:-'/sarathy'}
  APPS_HOME=${APPS_HOME:-"${SARATHY_HOME}/apps"}
  APP_NAME=$1
  APP_CMD=$2
  if [[ -z ${ENV+x} ]]; then ENV='dev'; fi
  if [[ -z ${EDITOR+x} ]]; then EDITOR=code-server; fi
  if [[ $APP_NAME == '' ]]; then echo "ERR: app taskfile name not given, exiting ..."; return 1; fi

  # let's find app file
  # TODO: check for if we've found > 1 file
  K8S_APPS=${APPS_HOME}/k8s
  APP_DIR=$(fd $APP_NAME $APPS_HOME)
  APP_TASKFILE=$APP_DIR/taskfile.yaml
  TASKFILE_LIB=${APPS_HOME}/taskfile-lib

  #echo $APP_NAME $EDITOR ':' $APP_DIR $APP_TASKFILE $APP_CMD $TASKFILE_LIB

  # let's pass all ARGS to task cmd except ARG1, as it's the APP_FILE
  TASKFILE=$APP_TASKFILE TASKFILE_LIB=$TASKFILE_LIB \
  APP_NAME=$APP_NAME APP_DIR=$APP_DIR \
  K8S_APPS=$K8S_APPS \
  EDITOR=$EDITOR \
  ENV=$ENV \
  ARCH=$ARCH \
    task -t $APP_TASKFILE "${@:2}"
}