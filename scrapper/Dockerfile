FROM debian:bullseye
ADD files/ /opt/
RUN mkdir /opt/template && \
    apt-get update && \
    apt-get install -y python3.7 python3-pip python3-lxml && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --upgrade setuptools && \
    pip3 install wheel flask bs4 requests_html
ENTRYPOINT [ "python3", "/opt/api.py" ]
