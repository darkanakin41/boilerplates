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
echo "[$APP] .env file loaded"
HELM_CONFIGURATION=$(checkHelmRepository)
if [[ -n $HELM_CONFIGURATION ]]
then
  echo "$HELM_CONFIGURATION"
  exit 1
fi
echo "[$APP] helm configuration loaded "

echo "$(installHelmRepository)"
COMMAND="helm show values $CHART_REPO_NAME/$CHART_NAME > $APP/values.dist.yaml"

eval "${COMMAND}"
