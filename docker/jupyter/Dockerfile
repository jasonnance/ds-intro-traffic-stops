FROM jupyter/minimal-notebook:7f1482f5a136

USER root

RUN apt-get update && apt-get install -y \
    graphviz

USER jovyan

COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt
