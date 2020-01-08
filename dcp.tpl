
BGRED=`echo -e "\033[41m"`
FGRED=`echo -e "\033[31m"`
FGBLUE=`echo -e "\033[35m"`
BGGREEN=`echo -e "\033[42m"`
FGGREEN=`echo -e "\033[32m"`

NORMAL=`echo -e "\033[m"`

if [ $# -gt 0 ]; then
    if [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        printf "\n\n --- Helper [shortcuts] for developers engine: ${COMPOSE} --- \n\n"
        echo "      ${NORMAL}use ${FGGREEN}dcp [command]${NORMAL}"
        echo "      All ${COMPOSE} commands ${FGGREEN}dcp [command] ${NORMAL}"
        echo "      Example: ${FGGREEN}dcp ps -a${NORMAL} show all containers"
        if [ "$COMPOSE" == "docker-compose" ]; then
            echo "      ${FGGREEN}dcp up ${NORMAL} run docker compose up -d"
            echo "      ${FGGREEN}dcp upfile [path to docker-compose.yml] ${NORMAL} run docker compose up --file docker-compose.yml -d"
            echo "      ${FGGREEN}dcp [reload|restart|rs|rl] ${NORMAL} run docker compose down && up -d"
        fi
        echo "      ${FGGREEN}dcp enter ${NORMAL} Go to inside container interactive [exec -it bash]"
        echo "      ${FGGREEN}dcp test$ [command] ${NORMAL} run phpunit test as a new layer in container"
        echo "      ${FGGREEN}dcp t [command] ${NORMAL} run phpunit in container"
        echo "      ${FGGREEN}dcp composer [command] ${NORMAL} run composer in container [if you have private repos use command ${FGRED}ssh-add${NORMAL} before]"
        echo "      ${FGGREEN}dcp npm [command] ${NORMAL} run npm commands as a new layer in container"
        printf "\n\n --- Thx for using, pls donate \$1 --- \n\n"
    elif [ "$1" == "up" ] && [ "$COMPOSE" == "docker-compose" ]; then
        echo "$COMPOSE up -d"
        $COMPOSE up -d
    elif [ "$1" == "upfile" ] && [ "$COMPOSE" == "docker-compose" ]; then
        shift 1
        echo "$COMPOSE up --file $@ -d"
        $COMPOSE up --file $@ -d
    elif [ "$COMPOSE" == "docker-compose" ] && [ "$1" == "reload" ] || [ "$1" == "restart" ] || [ "$1" == "rs" ] || [ "$1" == "rl" ]; then
        echo "$COMPOSE down && $COMPOSE up -d"
        $COMPOSE down && $COMPOSE up -d
    elif [ "$1" == "test" ]; then
        shift 1
        $COMPOSE run --rm -w /var/www/html ${SERVICE} ./tests/phpunit $@
    elif [ "$1" == "t" ]; then
        shift 1
        $COMPOSE exec ${SERVICE} bash -c "cd /var/www/html && ./tests/phpunit $@"
    elif [ "$1" == "enter" ]; then
        shift 1
        $COMPOSE exec -it ${SERVICE} bash
    elif [ "$1" == "composer" ]; then
        shift 1
        EXEC_CMD="cd /var/www/html && composer $@"
        $COMPOSE exec -it ${SERVICE} bash -c "$EXEC_CMD"
    elif [ "$1" == "npm" ]; then
        shift 1
        $COMPOSE run --rm -w /var/www/html node npm $@
    else
        echo "$COMPOSE  $@"
        $COMPOSE $@
    fi
else
    $COMPOSE ps
fi
