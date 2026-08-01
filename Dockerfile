FROM alpine:latest
COPY caythong.sh /caythong.sh
RUN apk add --update ncurses bash
ENV TERM=xterm-256color
CMD ["bash","/caythong.sh"]
