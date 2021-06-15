# Task 1

## Part 1
First thing I did is build it as is to see what I'm dealing with. Looks like it
comes in at 1.23GB so I used a `docker run` to enter a running instance of that
image. After that I browsed around to see what places were eating up the most
space with `du -sh *`

The #1 cause is due to the base image choice. It doesn't appear that this is a
super minimal image and `/usr/` has quite a few things that are not necessary.
I hopped on dockerhub to see what other node12 images were available and found
they have an alpine build. Those are usually super small so I decided to use
that. I did not experiment with the debian-slim images, nor do I have a specific
reason to exclude them.

The #2 cause was the node_modules folder which I think is best described by
this image:

![node_modules](https://camo.githubusercontent.com/98d81a9061d57563e0dfcf8a447e9142c97547e618719b9a4a7f9202fa911d12/68747470733a2f2f7062732e7477696d672e636f6d2f6d656469612f444549565f3158577341416c5932392e6a7067)

At this point, I broke the build up into a separate stage and added a prune to
clean up the modules folder. A build now uses 101MB so I stopped working further.

## Part 2
The first error is about the second volume for the db. It's not declared in the
volumes section so docker-compose is angry. I've never used docker-compose so
after installing it I looked for some docs:

https://docs.docker.com/compose/compose-file/compose-file-v3/#volumes

I quickly stole the bind volume syntax and updated the compose file which got me
passed that error.

The second error is the api trying to connect to 0.0.0.0:5432 which isn't going
to work. A quick grep of the source code showed me what I needed to modify:
```bash
grep -r 0.0.0.0 todo-api/
todo-api/src/database/database.providers.ts:const HOST_NAME = process.env.DB_HOST_NAME || '0.0.0.0';
todo-api/yarn.lock:  resolved "https://registry.yarnpkg.com/is-interactive/-/is-interactive-1.0.0.tgz#cea6e6ae5c870a7b0a0004070b7b587e0252912e"
```
Back to the docs for me to figure out how containers reference eachother with
compose:
https://docs.docker.com/compose/networking/

So I updated the environment section of the yml file to pass the hostname of the
database container. The containers are running now, tested localhost and I can
create todo lists and items now.

# Task 2
