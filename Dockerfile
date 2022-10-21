# start by pulling the python image
FROM python:3.8-alpine

RUN apk --no-cache add shadow 

# copy the requirements file into the image
COPY ./requirements.txt /app/requirements.txt

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

# copy every content from the local file to the image
COPY . /app

# Add user to disable root user
RUN useradd -ms /bin/bash emre
USER emre
WORKDIR /home/emre 

# configure the container to run in an executed manner
ENTRYPOINT [ "python" ]

CMD ["/app/flask_app.py"]
