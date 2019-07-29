FROM debian:jessie

RUN apt-get update && apt-get install -y curl

COPY run.sh /run.sh
RUN chmod +x /run.sh

COPY config/ /usr/share/config/

CMD ["/run.sh"]
