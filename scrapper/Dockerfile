FROM debian:bullseye
#ADD ./app/* /opt/
RUN mkdir /opt/template
RUN apt-get update && apt-get install -y \
    python3.7 python3-pip python3-lxml
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade setuptools
RUN pip3 install wheel && \
    pip3 install flask bs4 requests_html
#CMD [ "python3", "/opt/api.py" ]
