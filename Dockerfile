FROM kbase/kbase:sdkbase.latest
MAINTAINER KBase Developer
# -----------------------------------------

# Insert apt-get instructions here to install
# any required dependencies for your module.

# RUN apt-get update

# -----------------------------------------
RUN pwd

RUN mkdir -p /kb/module/work
RUN chmod 777 /kb/module

RUN perl /kb/module/third_party/install_ea_utils.pl

COPY ./ /kb/module

WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
