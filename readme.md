# Development
## Build Image and Run your container 
1. Step
    * create folders in your project `` build/docker/developer``
    * copy these script files into your project to `` build/docker/developer``
2. Step
    * script rights `` chmod +x build/docker/developer/buildAndRun.sh ``
3. Step
    * Variables
        * `` <<PORT>> `` - your container port ex: 8100
        * `` <<CONTAINER_NAME>> `` - your container name ex: john_doe_api
        * `` <<PROJECT_PATH>> `` - folder with your project files ex: /var/www/html/private/john_doe/api-gateway
        * `` <<DOCKER_ENGINE>> `` - [default docker] set engine "docker" or "docker-compose"
       
    * Run script `` bash ./build/docker/developer/buildAndRun.sh <<PORT>> <<CONTAINER_NAME>> <<PROJECT_PATH>> <<DOCKER_ENGINE>>``
    * Example 
        * Go to your project files `` cd /var/www/html/private/john_doe/api-gateway ``
        * Run script `` bash ./build/docker/developer/buildAndRun.sh 8100 john_doe_api $PWD ``  $PWD = represent your current PATH
4. Step
    * use docker helper manager 
        * composer install `` ./build/docker/developer/dcp composer install ``
        * run tests `` ./build/docker/developer/dcp test ``
        * run tests `` ./build/docker/developer/dcp t ``
        * show docker container list `` ./build/docker/developer/dcp ``
        * show help commands `` ./build/docker/developer/dcp help``
