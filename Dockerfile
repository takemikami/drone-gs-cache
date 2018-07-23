FROM google/cloud-sdk:alpine

LABEL maintainer="Takeshi Mikami" \
  org.label-schema.name="Drone GS Cache" \
  org.label-schema.vendor="Takeshi Mikami" \
  org.label-schema.schema-version="1.0"

ADD /bin/cache.sh /root/bin/cache.sh
RUN chmod 755 /root/bin/cache.sh

CMD /root/bin/cache.sh
