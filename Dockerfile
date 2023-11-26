# BUILD STAGE 1 - Clone Repo
FROM alpine AS clone
RUN apk --no-cache add git
WORKDIR /app
RUN git clone https://github.com/Stuart-Yee/Python-FLASK.git
COPY wsgi.py /app

# BUILD STAGE 2 - run app
FROM ubuntu AS execute
WORKDIR /app
COPY --from=clone /app/Python-FLASK/Checkerboard /app
COPY --from=clone /app/wsgi.py /app
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    nginx
RUN pip3 install flask 
RUN pip3 install gunicorn==19.6.0

EXPOSE 5000

# 0.0.0.1 is NOT a valid host to set up a listener
# using gunicorn to output to 0.0.0.0:5000
CMD gunicorn --bind 0.0.0.0:5000 wsgi:application

# run with the command docker run -p 5000:5000
# This will be reachable on 127.0.0.0.1:5000
# for deployment, will have to proxy output to 80 or 443