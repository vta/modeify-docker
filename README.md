# Modeify via Docker

```
Build Environment
OS: Ubuntu 16.04
RAM: 2GB +
SWAP: 4GB +
VPU: 2 +
Build Time: Approx 20 - 30 mins
```

## Building the image

### Configuration

  - You will have to configure the following files with your own values:
 
  ```
    deployment/config.yaml
    postfix/*
    ssl/*
    sites-available/*
  ```  
### Building the image
  - I have listed two alternatives to building this image using build arguments; on some machines I've had
  issues building using `docker-compose build` with `--build-arg` as it
  does not work the way its supposed to on some of my test boxes, forcing me to use a `docker build` command.
  It could be that different machines had different builds of docker-compose but I have not found that issue out yet.
  
  __Pulling config files from a private repo:__
  
  ``` 
  docker-compose build --build-arg SSH_KEY="$(cat ~/.ssh/id_rsa)" modeify
    
  docker build modeify/ --build-arg SSH_KEY="$(cat ~/.ssh/id_rsa)"   
  ```
  Note that the `SSH_KEY` build-arg is relating to the SSH key you have generated
  and attached to the private repo which should contain all your private / secret
  config files / keys.
  
  If you do not know how to generate an SSH key and attach it to your github / build system;
  You can read github's official documentation on how to do that here:
  
  https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/

  Once the key is generated; take the value within the generated .pub key file and insert it into
  your GitHub repo settings where it allows you to deploy keys.

```/php
@todo Bijan you did a nice job with OTP readme, all yours...
```

1. __VIP__ - hide the SSL certs
2. __VIP__ - hide the config.yaml & notify.yaml
3. __VIP__ - hide the postfix main.cf and sasl_passwd
4. Update this Readme and add our badges
5. Test thoroughly using the build-script.sh and inside the container
6. Document, verify and push to new EC2 - 2 VPUs, 2 GB RAM, 4 GB swapfile, 24 GB SSD
7. __VIP__ - DNS entry for __modeify.vta.org__ and __trips.vta.org__
 + *Please I've made this point several times...*
 + *Don't worry we'll keep __tripplanner.vta.org__ - we're just getting professional now, that's all ;)*
 + We'll move DNS records and redirect production when ready
 + Check with Kent / Vince -- DNS TTL = 300 --- no longer please
8. __VIP__ - Store and get secrets from a new VTA private repo :-)
 - please create a private repo called **vault**
 - then create a master origin folder with nothing
 - then create a new branch per application, ie:

 ```
    vta_otp-prod
    vta_otp-uat
    vta_otp-dev
    vta_apache-prod
    vta_apache-uat
    vta_apache-dev
    vta_modeify-prod
    etc... 
 ```
 - then we clone master, which is nothing...
 - run checkout branch for secrets that application / container / repo

  __the branch should unpack every secret where it belongs using relative paths or ...?__

 - you'll need to make a bot with a token & secret
 - me thinks, those go in an `.env` file that Docker hides, if I remember
9. Document all the new features since 1.9.x
 - Google Maps & Places or ESRI Maps
 - Print, Share, Email, Copy Link
 - Improved accuracy and performance
 - Improved intersections and address resolution
 - etc... check commit history and waffle done board archives
10. Add Locales en-US as seen in this Dockerfile - fixes some bugs
11. Add basic one-time simple Sitemap.xml file that can be indexed, why aren't we top of Google ?
12. __VIP__ - Create config.tmp.yml files and .env.tmp for others to adopt
13. Please fix robots.txt in OTP and Apache builds we did, they're wrong
14. Please fix this in our nice 2.2 tagged release, make it 2.2.1
    ```javascript
    modeify_1  | GET /example_video_stream.mjpeg?openalprfiletype=file.mjpg 200 0.396 ms - 4244
    ```

15. In this Docker repo, there's an issue with Apache ServerName
    ```javascript
     modeify_1  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.2. Set the 'ServerName' directive globally to suppress this message
    ```

16. As usual there's a build command
    ```/bin/bash
    /usr/bin/time --verbose --output=build-time-`date +"%F-%T"`.log /bin/bash -x ./build-docker.sh
    ```
17. Create proper `.env` files for everything

 - Meaning NODE_ENV vars for modeify
 - Like development, testing, production, uat
 - Clean up the config.yaml files
 - I think you'll need to grab notify.yaml from devplanner
18. Work on automated pipeline from GitHub to Docker hub
19. Keep in touch via Slack - I'm usually available for ?'s & chat or jokes
20. Let Bob know there was ImageMagick, Postfix and Proxy Request Headers

Say Hi Bob and team, hopefully I'll be back soon, cheers :)
