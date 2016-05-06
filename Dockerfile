FROM centos:7.2.1511
MAINTAINER mcenirm@uah.edu

RUN yum updateinfo
RUN yum -y install \
  make-1:3.82-21.el7.x86_64 \
  perl-4:5.16.3-286.el7.x86_64 \
  perl-Digest-SHA-1:5.85-3.el7.x86_64 \
  perl-ExtUtils-MakeMaker-6.68-3.el7.noarch \
  perl-Params-Validate-1.08-4.el7.x86_64 \
  perl-TermReadKey-2.30-20.el7.x86_64 \
  perl-Try-Tiny-0.12-2.el7.noarch \
  perl-XML-LibXML-1:2.0018-5.el7.x86_64 \
  perl-XML-Simple-2.20-5.el7.noarch

RUN yum -y install \
  epel-release-7-5.noarch
RUN yum updateinfo
RUN yum -y install \
  perl-Config-General-2.60-1.el7.noarch \
  perl-IO-All-0.61-1.el7.noarch \
  perl-JSON-XS-1:3.01-2.el7.x86_64 \
  perl-Log-Log4perl-1.42-2.el7.noarch \
  perl-Moose-2.1005-1.el7.x86_64 \
  perl-common-sense-3.6-4.el7.noarch

COPY rex.repo /etc/yum.repos.d/rex.repo
WORKDIR /var/tmp
COPY RPM-GPG-KEY-REXIFY-REPO ./
RUN rpm --import RPM-GPG-KEY-REXIFY-REPO
RUN rm RPM-GPG-KEY-REXIFY-REPO
RUN yum updateinfo
RUN yum -y install \
  perl-Mojolicious-5.39-1.x86_64 \
  perl-Term-ProgressBar-2.16-1.x86_64

WORKDIR /var/tmp
COPY Rex-Repositorio-1.1.0.tar.gz ./
RUN tar xf Rex-Repositorio-1.1.0.tar.gz
RUN rm Rex-Repositorio-1.1.0.tar.gz

WORKDIR /var/tmp/Rex-Repositorio-1.1.0
RUN perl Makefile.PL
RUN make
RUN make test
RUN make install
WORKDIR /var/tmp
RUN rm -r Rex-Repositorio-1.1.0

RUN mkdir -p /etc/rex
COPY log4perl.conf /etc/rex/log4perl.conf
RUN ln -s /mirror/etc/repositorio.conf /etc/rex/repositorio.conf

VOLUME /mirror

ENTRYPOINT repositorio --mirror --repo=all
