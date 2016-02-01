alias vi=vim
alias tmux="~/bin/tmux -2"
alias lf="ls -FC --color"

export  LS_COLORS="no=00:fi=00:di=01;35:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"
export LC_ALL=C
export LANG=en_US

function json_pp
{

  node -e "
    var stdin = process.openStdin();
    var EventEmitter = require('events').EventEmitter;

    var buffer = '';

    stdin.setEncoding('utf8');
    stdin.on('data', function (chunk) {
        buffer += chunk;
    });

    stdin.on('end', function () {
        if (buffer.slice(0,5) === 'HTTP/') {
            var index = buffer.indexOf('\r\n\r\n');
            var sepLen = 4;
            if (index == -1) {
                index = buffer.indexOf('\n\n');
                sepLen = 2;
            }
            if (index != -1) {
                process.stdout.write(buffer.slice(0, index+sepLen));
                buffer = buffer.slice(index+sepLen);
            }
        }
        if (buffer[0] === '{' || buffer[0] === '[') {
            try {
                process.stdout.write(JSON.stringify(JSON.parse(buffer), null, 2));
                process.stdout.write('\n');
            } catch(ex) {
                process.stdout.write(buffer);
                if (buffer[buffer.length-1] !== '\n') {
                    process.stdout.write('\n');
                }
            }
        } else {
            process.stdout.write(buffer);
            if (buffer[buffer.length-1] !== '\n') {
                process.stdout.write('\n');
            }
        }
    });
  "
}

#
# uncomment [<file>] - removes comments from the file (or stdin)
#
uncomment()
{
    cat $* | egrep -v '[    ]*#.*'
}

# normal: black:0, red:1, green:1, yellow:3, blue: 4, magenta: 5, cyan: 6, white: 7
# bright: black:8, red:9, green:10, yellow:11, blue: 12, magenta: 13, cyan: 14, white: 15

function colour
{
    if [ ! -z "$1" ]
    then
        printf "\x1b[38;5;${1}m"
        return
    fi

    for i in {0..255}
    do
        printf "\x1b[38;5;${i}mcolour${i}\n"
    done
}

function bgcolour
{
    if [ ! -z "$1" ]
    then
        printf "\x1b[48;5;${1}m"
        return
    fi

    for i in {0..255}
    do
        printf "\x1b[48;5;${i}mcolour${i}\n"
    done
}


