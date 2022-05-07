#!/bin/sh
SERVER_TYPE=${TYPE:-"VANILLA"}

resolveHandler()
{
  case "$1" in
    "VANILLA" | "FABRIC")
      echo "vanilla_handler"
    ;;
    "FORGE")
      echo "forge_handler"
    ;;
    "BUKKIT" | "SPIGOT")
      if [ -z "$2" ] || [ "$2" = "LATEST" ]; then
        echo "bukkit14_handler"
      fi
      MINOR_VERSION=echo $2 | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sed -r 's/^[0-9]+\.([0-9]+)\.[0-9]+$/\1/'
      if [ -z "MINOR_VERSION" ]; then
        echo "Invalid version number"
        exit 1
      fi
      if [ $(($MINOR_VERSION)) -ge 14 ]; then
        echo "bukkit14_handler"
      else
        echo "bukkit_handler"
      fi
    ;;
    "PAPER" | "MOHIST")
      echo "bukkit_handler"
    ;;
    "CATSERVER")
      echo "cat_server_handler"
    ;;
    *)
      echo "vanilla_handler"
    ;;
  esac
}

echo "Starting server setup..."
OUTPUT=$(SETUP_ONLY=true /start)
START_COMMAND=$(echo $OUTPUT | grep -oE 'SETUP_ONLY: .+' | sed -r 's/^SETUP_ONLY: (.+)$/\1/')
if [ -z "$START_COMMAND" ]; then
  echo "Command is empty, exiting..."
  exit 1
fi
echo "Using start command '$START_COMMAND'"
sed -i "/start_command:/s/%start%/\"$START_COMMAND\"/" /tmp/mcdr/config.yml

HANDLER=$(resolveHandler $SERVER_TYPE $VERSION)
if [ -z "$HANDLER" ]; then
  echo "Handler is empty, exiting..."
  exit 1
fi
echo "Using handler '$HANDLER'"
sed -i "/handler:/s/%handler%/\"$HANDLER\"/" /tmp/mcdr/config.yml

mkdir -p /mcdr/config
mkdir -p /mcdr/logs
mkdir -p /mcdr/plugins

cat /tmp/mcdr/config.yml

if [ -f "/mcdr/config.yml" ]; then
  echo "Config file 'config.yml' exists"
else
  echo "Config file 'config.yml' does not exist, using default config"
  mv -n /tmp/mcdr/config.yml /mcdr/config.yml
fi

if [ -f "/mcdr/permission.yml" ]; then
  echo "Config file 'permission.yml' exists"
else
  echo "Config file 'permission.yml' does not exist, using default config"
  mv -n /tmp/mcdr/permission.yml /mcdr/permission.yml
fi

python3 -m mcdreforged