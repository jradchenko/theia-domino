#FROM jonrad/theia-datascience:latest as develop

FROM quay.io/domino/base:Ubuntu18_DAD_Py3.6_R3.6_20190918 AS base
RUN npm install -g yarn n
RUN n install 12

FROM base AS theia

COPY . /var/opt/workspaces/theia
RUN cd /var/opt/workspaces/theia && yarn
#COPY --from=develop /home/theia /var/opt/workspaces/theia
#RUN cd /var/opt/workspaces/theia && yarn install

# R 
RUN sudo -u ubuntu R -e "install.packages('rstudioapi', repos='https://cran.rstudio.com/')"

# Jupyter
ENV ENV_JUPYTER_PATH=/usr/local/anaconda/bin/jupyter-notebook

#RUN echo cd /var/opt/workspaces/theia >> /var/opt/workspaces/theia/start.sh && \
#  echo node /var/opt/workspaces/theia/browser-app/src-gen/backend/main.js /mnt --hostname 0.0.0.0 --rstudio-old-version true --theia-home-path \${DOMINO_PROJECT_OWNER}/\${DOMINO_PROJECT_NAME}/notebookSession/\${DOMINO_RUN_ID} \$@ \
#  >> /var/opt/workspaces/theia/start.sh

RUN echo cd /var/opt/workspaces/theia >> /var/opt/workspaces/theia/start.sh && \
  echo node /var/opt/workspaces/theia/applications/browser/src-gen/backend/main.js /mnt --hostname 0.0.0.0 --rstudio-old-version true --log-level debug --theia-home-path \${DOMINO_PROJECT_OWNER}/\${DOMINO_PROJECT_NAME}/notebookSession/\${DOMINO_RUN_ID} \$@ >> /var/opt/workspaces/theia/start.sh
RUN chmod 755 /var/opt/workspaces/theia/start.sh
