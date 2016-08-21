#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

/*
 (Standard 2 clause BSD licence)

 Copyright (c) 2012, 2016 David Brownlee <abs@absd.org>
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

static int inputline();
static void wopr(char ch);

#define LINE_LENGTH 1024
#define TELNET_IAC 255
#define TELNET_MIN_COMMAND 240

int cdelay = 10 * 1000;
int ldelay = 10 * 1000;

int main(int argc, char **argv)
{
    extern char *optarg;
    extern int optind;
    int iflag = 0;
    int nflag = 0;
    int ch;

    while ((ch = getopt(argc, argv, "c:il:n")) != -1) {
            switch (ch) {
            case 'i':
		    iflag = 1;
                    break;
            case 'c':
		    cdelay = atoi(optarg) * 1000;
                    break;
            case 'l':
		    ldelay = atoi(optarg) * 1000;
                    break;
            case 'n':
                    nflag = 1;
                    break;
            case '?':
            default:
		    fprintf(stderr, "usage: wopr [opt] arg [arg2 ...]\n");
		    fprintf(stderr, "opt: -c msec Delay per character\n");
		    fprintf(stderr, "     -i      Read and (cleanup telnet) input line\n");
		    fprintf(stderr, "     -l msec Delay per line\n");
		    fprintf(stderr, "     -n      No new line\n");
                    exit(EXIT_FAILURE);
            }
    }
    argc -= optind;
    argv += optind;

    if (iflag) {
        exit(inputline());
    }
    if (!*argv && ! nflag)
	wopr('\n');
    while (*argv)
	{
	char *ptr;
	for (ptr = *argv ; *ptr ; ++ptr)
	    wopr(*ptr);
	if (! nflag)
	    wopr('\n');
	++argv;
	}
    exit(EXIT_SUCCESS);
}

static int inputline() {
    char buf[LINE_LENGTH];
    char *ptr;
    char *endptr;

    if (fgets(buf, sizeof(buf), stdin) == NULL) {
        return EXIT_FAILURE;
    }
    ptr = buf;

    /* Very simplistic - assumes all commands take a single character arg */
    for (ptr = buf ; (unsigned char)*ptr == TELNET_IAC &&
        (unsigned char)ptr[1] >= TELNET_MIN_COMMAND && ptr[2]; ptr += 3) {
        ;
    }

    /* Strip trailing newline or CR - to handle telnet raw mode */
    endptr = strchr(ptr, 0);
    while (endptr > ptr && (endptr[-1] == 0x0d || endptr[-1] == 0x0a)) {
      --endptr;
    }
    *endptr = 0;

    fputs(ptr, stdout);
    return EXIT_SUCCESS;
}

static void wopr(char ch)
{
    write(1, &ch, 1);
    usleep(ch == '\n' ? ldelay : cdelay);
}
