FROM kbase/kbase:sdkbase.latest
MAINTAINER KBase Developer
# -----------------------------------------

# Insert apt-get instructions here to install
# any required dependencies for your module.

# RUN apt-get update

# -----------------------------------------
RUN pwd

RUN mkdir -p /kb/module/work
RUN mkdir -p /kb/module/third_party
RUN chmod -R 777 /kb/module

COPY ./third_party /kb/module/third_party
RUN perl /kb/module/third_party/install_ea_utils.pl

# update installed WS client (will now include get_objects2)
RUN mkdir -p /kb/module && \
    cd /kb/module && \
    git clone https://github.com/kbase/workspace_deluxe && \
    cd workspace_deluxe && \
    git checkout 696add5 && \
    rm -rf /kb/deployment/lib/biokbase/workspace && \
    cp -vr lib/biokbase/workspace /kb/deployment/lib/biokbase/workspace && \
    cd /kb/module && \
    rm -rf workspace_deluxe

COPY ./ /kb/module
RUN chmod -R a+rw /kb/module
WORKDIR /kb/module

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
