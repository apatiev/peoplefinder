FROM ubuntu:14.04
WORKDIR /tmp
COPY . /tmp
RUN sed -ri 's/archive.ubuntu.com/ru.archive.ubuntu.com/g' /etc/apt/sources.list
# If ubuntu == 16.04
#RUN apt-get update && apt-get install -y sudo
RUN bash setup.sh
EXPOSE 80
CMD ["/etc/init.d/kannel restart && /etc/init.d/nginx restart"]