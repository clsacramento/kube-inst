# Run your first app locally

## Verify files
```
$ ls
Dockerfile app.py requirements.txt
```

## Build image

```
$ docker build -t firstapp .
Sending build context to Docker daemon  4.608kB
Step 1/7 : FROM python:2.7-slim
2.7-slim: Pulling from library/python
ad74af05f5a2: Pull complete 
8812637047e3: Pull complete 
be169522399f: Pull complete 
286703095347: Pull complete 
Digest: sha256:5d668aa50cac534b08df02d942a6d1e9e71b38da9386ee54b3312be0af138469
Status: Downloaded newer image for python:2.7-slim
 ---> 451c85955bc2
Step 2/7 : WORKDIR /app
...<output omitted>
 ---> Running in c9c94769c76c
 ---> 6a14028fa48d
Removing intermediate container c9c94769c76c
Step 7/7 : CMD python app.py
 ---> Running in 1275d52850ec
 ---> 5c4528f3de21
Removing intermediate container 1275d52850ec
Successfully built 5c4528f3de21
Successfully tagged firstapp:latest

$ docker images
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
firstapp             latest              5c4528f3de21        8 minutes ago       194MB

```

## Run the app
```
$ docker run -p 4000:80 firstapp
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
^C
```

## Run the app on the background

```
$ docker run -d -p 4000:80 firstapp
916452e97dc497c7885ff9c6babb43b71a437898d2fbe415e429e9d1ce09c2c4

## List and stop containers
```
$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
916452e97dc4        firstapp            "python app.py"     2 minutes ago       Up 2 minutes        0.0.0.0:4000->80/tcp   vigilant_jang

$ docker stop 916452e97dc4
916452e97dc4
```
