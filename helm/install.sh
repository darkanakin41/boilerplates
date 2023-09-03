#!/bin/zsh

APP=$1

function checkApp() {
  if [[ -z $APP ]]
  then
    echo "No app defined"
    return
  fi

  if [[ ! -d $APP ]]
  then
    echo "[$APP] Not a valid app folder"
    return
  fi

  if [[ ! -f "$APP/.env" ]]
  then
    echo "[$APP] Missing proper .env configuration"
    return
  fi
}
function checkAppConfiguration() {
  if [[ -z $NAMESPACE ]]
  then
    echo "[$APP] Missing NAMESPACE configuration in .env"
  fi

  if [[ -z $NAME ]]
  then
    echo "[$APP] Missing NAME configuration in .env"
    exit 1
  fi

  if [[ -z $CHART_NAME ]]
  then
    echo "[$APP] Missing CHART_NAME configuration in .env"
  fi
}
function checkHelmRepository() {
  if [[ -z $CHART_REPO_NAME ]]
  then
    echo "[$APP] Missing CHART_REPO_NAME configuration in .env"
    return
  fi
  if [[ -z $CHART_REPO_URL ]]
  then
    echo "[$APP] Missing CHART_REPO_NAME configuration in .env"
    return
  fi
}
function installHelmRepository() {
  HELM_REPO_LIST=$(helm repo list)
  if [[ $(echo "$HELM_REPO_LIST" | grep "$CHART_REPO_URL") ]]
  then
    echo "[$APP] Repo already installed"
    return
  fi

  helm repo add $CHART_REPO_NAME $CHART_REPO_URL >/dev/null
  helm repo update >/dev/null
  echo "[$APP] Repo installed"
}

APP_CHECK=$(checkApp)
if [[ -n $APP_CHECK ]]
then
  echo "$APP_CHECK"
  exit 1
fi

source "$APP/.env"

APP_CONFIGURATION=$(checkAppConfiguration)
if [[ -n $APP_CONFIGURATION ]]
then
  echo "$APP_CONFIGURATION"
  exit 1
fi

echo "[$APP] .env file loaded"
HELM_CONFIGURATION=$(checkHelmRepository)
if [[ -n $HELM_CONFIGURATION ]]
then
  echo "$HELM_CONFIGURATION"
  exit 1
fi
echo "[$APP] helm configuration loaded "

echo "$(installHelmRepository)"
COMMAND="helm upgrade --install $NAME $CHART_REPO_NAME/$CHART_NAME --namespace $NAMESPACE --create-namespace"

if [[ -f "$APP/values.yaml" ]]
then
  COMMAND="$COMMAND --values=$APP/values.yaml"
fi

if [[ -n $INSTALL_ARGS ]]
then
  COMMAND="$COMMAND $INSTALL_ARGS"
fi

if [[ -f "$APP/pre-install.sh" ]]
then
  source "$APP/pre-install.sh"
fi

eval ${COMMAND}

if [[ -f "$APP/post-install.sh" ]]
then
  source "$APP/post-install.sh"
fi
