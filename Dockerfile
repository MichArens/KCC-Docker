FROM python:3.8-slim

# Set the working directory inside the container
WORKDIR /app

# Copy your Python script into the container
# COPY deploy/kcc-master/ /app/kcc/
COPY deploy/kindlegen /app/
COPY deploy/base_options.json /app/options.json

RUN mkdir input
RUN mkdir output
#Installing KindleGen
RUN mv kindlegen /usr/local/bin/

# Install any necessary dependencies (if your script requires any)
# Define the command to run your Python script
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y pip && \
    apt-get install -y git && \
    apt-get install -y p7zip-full && \
    apt-get install -y calibre && \
    apt-get -y install cmake protobuf-compiler

RUN git clone -b v5.6.3 https://github.com/ciromattia/kcc.git
RUN pip install --use-pep517 mozjpeg-lossless-optimization>=1.1.2

#Changing requirements
COPY deploy/requirements.txt /app/kcc/requirements.txt

#Installing requirements
RUN pip install -r /app/kcc/requirements.txt

#Manga downloader
RUN git clone https://github.com/manga-py/manga-py.git
RUN pip install -r /app/manga-py/requirements.txt

#Copy python code into docker
COPY deploy/Utils/. /app/Utils/
COPY deploy/manga_downloader.py /app/
COPY deploy/index.py /app/
# CMD python ./kcc/kcc-c2e.py -p K1 ./input/input.zip
CMD python index.py
