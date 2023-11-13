FROM ubuntu:23.04
LABEL maintainer="andrewlunde <andrew.lunde@sap.com>"
FROM thetalabsorg/edgelauncher_mainnet:v1.1.0
#FROM thetalabsorg/edgelauncher_mainnet:latest
##CMD ["/bin/sh" "-c" "/bin/start.sh"]

RUN mkdir -p /edgelauncher/data/mainnet
#RUN mkdir -p /edgelauncher/data/mainnet/anycast
#RUN mkdir -p /edgelauncher/data/mainnet/edgecore
#RUN mkdir -p /edgelauncher/data/mainnet/edgeencoder

#ADD ./edgelauncher/config.yaml /edgelauncher/data/mainnet/config.yaml
#ADD ./edgelauncher/edgecore/config.yaml /edgelauncher/data/mainnet/edgecore/config.yaml
#ADD ./edgelauncher/edgeencoder/config.yaml /edgelauncher/data/mainnet/edgeencoder/config.yaml
ADD ./edgelauncher/staking-summary /bin/staking-summary
RUN chmod a+x /bin/staking-summary

ADD ./edgelauncher/encoding-jobs /bin/encoding-jobs
RUN chmod a+x /bin/encoding-jobs

ADD ./edgelauncher/encoding-status /bin/encoding-status
RUN chmod a+x /bin/encoding-status

ADD ./edgelauncher/fedml-jobs /bin/fedml-jobs
RUN chmod a+x /bin/fedml-jobs

ADD ./edgelauncher/lavita-jobs /bin/lavita-jobs
RUN chmod a+x /bin/lavita-jobs

RUN echo 'echo ""' > /root/.bashrc && \
    echo 'echo "Theta EdgeNode started in the background."' >> /root/.bashrc && \
    echo 'echo "Run staking-summary command to display the Staking Summary for this EdgeNode."' >> /root/.bashrc && \
    echo 'echo "Other commands: encoding-jobs, encoding-status, fedml-jobs, lavita-jobs"' >> /root/.bashrc && \
    echo 'echo ""' >> /root/.bashrc  && \
    echo "export PS1='\h:\w\$ '" >> /root/.bashrc

ENV EDGELAUNCHER_CONFIG_PATH=/edgelauncher/data/mainnet
ENV PASSWORD=LivinOnTheEdge
#RUN apt-get update && apt-get install -y curl
#WORKDIR /src
#COPY . .

EXPOSE 80
EXPOSE 15888
EXPOSE 17888
EXPOSE 17935

RUN apt-get -y update && \
    apt-get install -y htop lsof && \
    apt-get install -y curl jq vim && \
    VERSION=v1.0.1 && \
    curl -sLk https://github.com/yudai/gotty/releases/download/$VERSION/gotty_linux_amd64.tar.gz \
    | tar xzC /usr/local/bin && \
#    apt-get purge --auto-remove -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists*

#ENTRYPOINT ["/usr/local/bin/gotty"]

#CMD ["--permit-write","--reconnect","/bin/bash"]

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
