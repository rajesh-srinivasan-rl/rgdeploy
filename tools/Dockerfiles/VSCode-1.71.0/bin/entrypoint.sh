#!/bin/sh
set -eu

export PS1='\w $ '

EXTENSIONS="${EXTENSIONS:-none}"
LAB_REPO="${LAB_REPO:-none}"

eval "$(fixuid -q)"

mkdir -p /home/ec2-user/workspace
mkdir -p /home/ec2-user/.local/share/code-server/User
cat > /home/ec2-user/.local/share/code-server/User/settings.json << EOF
{
    "workbench.colorTheme": "Visual Studio Dark"
}
EOF
chown ec2-user /home/ec2-user/workspace
chown -R ec2-user /home/ec2-user/.local

if [ "${DOCKER_USER-}" ]; then
  echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
  sudo usermod --login "$DOCKER_USER" ec2-user
  sudo groupmod -n "$DOCKER_USER" ec2-user
  USER="$DOCKER_USER"
  sudo sed -i "/ec2-user/d" /etc/sudoers.d/nopasswd
fi

if [ ${EXTENSIONS} != "none" ]
    then
      echo "Installing Extensions"
      for extension in $(echo ${EXTENSIONS} | tr "," "\n")
        do
          if [ "${extension}" != "" ]
            then
              dumb-init /usr/bin/code-server \
                --install-extension "${extension}" \
                /home/ec2-user
	  fi
        done
fi

if [ ${LAB_REPO} != "none" ]
  then
    cd workspace
    git clone ${LAB_REPO}
    cd ..
fi

if [ ${HTTPS_ENABLED} = "true" ]
  then
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      --cert /home/ec2-user/.certs/cert.pem \
      --cert-key /home/ec2-user/.certs/key.pem \
      /home/ec2-user/workspace
else
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      /home/ec2-user/workspace
fi
