FROM alpine:latest

WORKDIR /usr/bin

# Use the latest builds of Alpine packages.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && apk --no-cache add clamav clamav-libunrar \
    && mkdir /run/clamav \
    && chown clamav:clamav /run/clamav

RUN sed -i 's/^#Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf \
    && sed -i 's/^#TCPSocket .*$/TCPSocket 3310/g' /etc/clamav/clamd.conf \
    && sed -i 's/^#Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

RUN freshclam --quiet

COPY entrypoint.sh .

EXPOSE 3310

ENTRYPOINT [ "./entrypoint.sh" ]

