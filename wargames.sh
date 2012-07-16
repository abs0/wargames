#!/bin/sh

# (Standard 2 clause BSD licence)
# 
# Copyright (c) 2012 David Brownlee <abs@absd.org>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Add the directory containing this script to the path
case "$0" in
    /*) PATH=$PATH:$(dirname $0) ;;
    *)  PATH=$PATH:$(dirname $PWD/$0) ;;
esac

# Global variables
# $a      Last input
# $prompt Last prompt
# $phase  Interaction phase (connect|logon|games|falken|gtn)

# Check the input ($a) against actual in-film input and fixup display if needed
actual()
{
    if [ "$a" != "$1" ] ; then
	tput cuu1 ; tput dl1; echo "$prompt$1"
    fi
}

# Call actual, then output a new line and delay
actual_d()
{
    actual "$1"
    echo ; sleep 1
}

# Not actually in the film, a convenience to get back to the login screen
logout()
{
wopr -c 800 .....
wopr -- "" "--LOGOUT--" "" ""
sleep 1
phase=logon
}

phase_connect()
{
clear
wopr -c 15 "									" \
     "									" \
     "									"
}

phase_logon()
{
    prompt="LOGON:  "
    wopr -n "$prompt"
    read a

    case "$a" in
	"Help Logon" | "help logon" | Help | help )
	    actual_d "Help Logon"
	    wopr "HELP NOT AVAILABLE"
	    ;;
	Joshua | joshua)
	    actual_d "Joshua"
	    phase=falken
	    return
	    ;;
	"Help Games" | "help games")
	    actual_d "Help Games"
	    wopr "'GAMES' REFERS TO MODELS, SIMULATIONS AND GAMES" \
	         "WHICH HAVE TACTICAL AND STRATEGIC APPLICATIONS."
	    phase=games
	    ;;
	Falkens-Maze | Armageddon )
	    actual_d "$a"
	    wopr -- "IDENTIFICATION NOT RECOGNIZED BY SYSTEM" \
	         "--CONNECTION TERMINATED--" ""
	    sleep 1
	    exit
	    ;;
	'')
	    ;;
	000001 | * )
	    actual_d 000001
	    wopr -- "IDENTIFICATION NOT RECOGNIZED BY SYSTEM" \
	         "--CONNECTION TERMINATED--" ""
	    sleep 1
	    exit
	    ;;
    esac
    wopr '' ''
}

phase_games()
{ 
    prompt=
    read a

    case "$a" in
	"List Games" | "list games")
	    actual_d "List Games"
	    wopr -c 10 -l 550 -n "FALKEN'S MAZE
BLACK JACK
GIN RUMMY
HEARTS
BRIDGE
CHECKERS
CHESS
POKER
FIGHTER COMBAT
GUERRILLA ENGAGEMENT
DESERT WARFARE
AIR-TO-GROUND ACTIONS
THEATERWIDE TACTICAL WARFARE
THEATERWIDE BIOTOXIC AND CHEMICAL WARFARE

GLOBAL THERMONUCLEAR WAR"
	    ;;
	*War* | *war* ) # Actually endgame phase
	    actual_d "Global Thermonuclear War"
	    wopr "A STRANGE GAME." \
	         "THE ONLY WINNING MOVE IS" \
	         "NOT TO PLAY." \
		 ""
	    sleep 1.5
	    wopr "HOW ABOUT A NICE GAME OF CHESS?"
	    ;;
	*Joshua* | *joshua* )
	    actual_d "LOGON:  Joshua"
	    phase=falken
	    ;;
	'' )
	    phase=logon
	    ;;
    esac
    wopr '' ''
}

phase_falken()
{
    clear
    wopr -c 0 -l 25 "\
#45     11456          11009          11893          11972        11315
PRT CON. 3.4.5.  SECTRAN 9.4.3.                      PORT STAT: SD-345

(311) 699-7305
"
    clear
    printf "\n\n\n\n\n\n\n"
    wopr -c 0 -l 25 "\
(311) 767-8739
(311) 936-2364
-           PRT. STAT.                                   CRT. DEF.
||||||||||||||==================================================
FSKDJLSD: SDSDKJ: SBFJSL:                           DKSJL: SKFJJ: SDKFJLJ:
SYSPROC FUNCT READY                            ALT NET READY
CPU AUTH RY-345-AX3            SYSCOMP STATUS  ALL PORTS ACTIVE
22/34534.90/3209                                          11CVB-3904-3490
(311) 935-2364
"
    clear
    sleep 0.5
    wopr "GREETINGS PROFESSOR FALKEN." ""
    prompt=
    while true ; do
	read a
	case "$a" in
	    # 1st pass
	    Hello* | hello*)
		actual_d "Hello."
		wopr "" "HOW ARE YOU FEELING TODAY?" ""
		;;
	    *fine* | *"ow are you"* )
                actual_d "I'm fine. How are you?"
		wopr "" \
                     "EXCELLENT.  IT'S BEEN A LONG TIME.  CAN YOU EXPLAIN" \
		     "THE REMOVAL OF YOUR USER ACCOUNT NUMBER ON 6/23/73?" \
		     ""
		;;
	    *mistak*)
		actual_d "People sometimes make mistakes." # mistak
		wopr "" "YES THEY DO.  SHALL WE PLAY A GAME?" ""
		;;
	    *love* | *war\?* | *war)
	        actual_d "Love to. How about Global Thermonuclear War?"
	        wopr "" "WOULDN'T YOU PREFER A GOOD GAME OF CHESS?" ""
		;;
	    *later* | *war. )
		actual_d "Later. Lets play Global Thermonuclear War."
		wopr -n "" "FINE"
		phase=gtn
		return
		;;
	    #
	    # 2nd pass
	    *incorrect* | *Incorrect* | *"not falken"* | *"not Falken"* )
	        actual "Incorrect identification.  I am not Falken."
		;;
	    *dead*)
	        actual_d "Falken is dead."
		wopr "" "I'M SORRY TO HEAR THAT, PROFESSOR." ""
		sleep 1
		wopr "YESTERDAY'S GAME WAS INTERRUPTED." ""
		sleep 1
		wopr "ALTHOUGH PRIMARY GOAL HAS NOT YET" \
		     "BEEN ACHIEVED, SOLUTION IS NEAR." \
		     ""
		;;
	    *goal* | "What is"* | "what is"* )
                actual_d "What is the primary goal?"
		if [ "$goal" != 2 ]; then
		    goal=2
		    wopr "" "YOU SHOULD KNOW PROFESSOR" \
		         "YOU PROGRAMMED ME." \
			 ""
		else
		    goal=1
		    wopr "" "TO WIN THE GAME." ""
		    logout
		    return
		fi
		;;
	    #
	    # 3rd pass
	    *"still play"*)
                actual_d "Hello, are you still playing the game?"
		wopr "" \
                     "OF COURSE. I SHOULD REACH DEFCON 1 AND LAUNCH MY MISSILES IN 61 HOURS." \
		     "WOULD YOU LIKE TO SEE SOME PROJECTED KILL RATIOS" \
                     "" \
		     "[pages of kill ratios]" \
                     ""
		;;
	    *game* | *real* )
                actual_d "Is this a game or is it real?"
		wopr "" "WHAT'S THE DIFFERENCE?" ""
		sleep 1
		wopr "YOU ARE A HARD MAN TO REACH.  I COULD NOT FIND" \
		     "YOU IN SEATTLE AND NO TERMINAL IS IN" \
		     "OPERATION AT YOUR CLASSIFIED ADDRESS." \
	             ""
		;;
	    *address*)
                actual_d "What classified address?"
		wopr "" \
		     "DOD PENSION FILES INDICATE" \
		     "CURRENT MAILING AS:" \
		     "" \
		     "DR. ROBERT HUME (A.K.A. STEPHEN W. FALKEN)" \
		     "5 TALL CEDAR ROAD" \
		     "GOOSE ISLAND, OREGON 97014" \
	             ""
		logout
		return
		;;

	    *) 
		;;
	esac
    done
}

phase_gtn()
{
sleep 2
clear
wopr -c 5 -n "
<map>


           UNITED STATES           SOVIET UNION

     WHICH SIDE DO YOU WANT?

	1.   UNITED STATES
	2.   SOVIET UNION

      PLEASE CHOOSE ONE:  2"
    read a # 2
    wopr "" "" "" "\
AWAITING FIRST STRIKE COMMAND
-----------------------------

PLEASE LIST PRIMARY TARGETS BY
CITY AND/OR COUNTY NAME:
"
prompt=
read a
actual "Las Vegas"
read a
actual "Seattle"
sleep 0.5
clear
wopr -c 0 -l 25 "
           UNITED STATES           SOVIET UNION


TRAJECTORY HEADING  TRAJECTORY HEADING  TRAJECTORY HEADING  TRAJECTORY HEADING  
------------------  ------------------  ------------------  ------------------
A-SS20-A 526 523    C-SS20-A 243 587    E-SS20-A 398 984    G-SS20-A 909 437
       B 824 235           B 852 754           B 394 345           B 132 147
       C 125 285           C 174 256           C 427 343           C 095 485
       D 758 247           D 364 867           D 251 953           D 489 794
       E 423 234           E 873 543           E 093 684           E 025 344

A-SS20-A 526 523    C-SS20-A 243 587    E-SS20-A 398 984    G-SS20-A 909 437
       B 824 235           B 852 754           B 394 345           B 132 147
       C 125 285           C 174 256           C 427 343           C 095 485
       D 758 247           D 364 867           D 251 953           D 489 794
       E 423 234           E 873 543           E 093 684           E 025 344
"
logout
}

phase_connect
phase=logon
while true; do
    phase_$phase
done

exit

------- First connection --------

LOGON:  000001

IDENTIFICATION NOT RECOGNIZED BY SYSTEM
--CONNECTION TERMINATED--


LOGON:  Help Logon

HELP NOT AVAILABLE


LOGON:  Help Games

'GAMES' REFERS TO MODELS, SIMULATIONS AND GAMES
WHICH HAVE TACTICAL AND STRATEGIC APPLICATIONS.


List Games

FALKEN'S MAZE
BLACK JACK
GIN RUMMY
HEARTS
BRIDGE
CHECKERS
CHESS
POKER
FIGHTER COMBAT
GUERRILLA ENGAGEMENT
DESERT WARFARE
AIR-TO-GROUND ACTIONS
THEATERWIDE TACTICAL WARFARE
THEATERWIDE BIOTOXIC AND CHEMICAL WARFARE

GLOBAL THERMONUCLEAR WAR

[end session]

-------- Montage1 --------

LOGON:  Falkens-Maze

IDENTIFICATION NOT RECOGNIZED BY SYSTEM
--CONNECTION TERMINATED--

-------- Montage2 --------

LOGON:  Armageddon


IDENTIFICATION NOT RECOGNIZED BY SYSTEM
--CONNECTION TERMINATED--

-------- Initial successful logon --------

LOGON:  Joshua

<delay, clear>
#45     11456          11009          11893          11972        11315
PRT CON. 3.4.5.  SECTRAN 9.4.3.                      PORT STAT: SD-345

(311) 699-7305
<someinverse video text, clear>
<stuff, clear>

GREETINGS PROFESSOR FALKEN.

Hello.


HOW ARE YOU FEELING TODAY?

I'm fine. How are you?


EXCELLENT.  IT'S BEEN A LONG TIME.  CAN YOU EXPLAIN
THE REMOVAL OF YOUR USER ACCOUNT NUMBER ON 6/23/73?

People sometimes make mistak


YES THEY DO.  SHALL WE PLAY A GAME?

Love to. How about Global Thermonuclear War?


WOULDN'T YOU PREFER A GOOD GAME OF CHESS?

Later. Lets play Global Thermonuclear War.


FINE

           UNITED STATES           SOVIET UNION


TRAJECTORY HEADING  TRAJECTORY HEADING  TRAJECTORY HEADING  TRAJECTORY HEADING  
------------------  ------------------  ------------------  ------------------
A-SS20-A 526 523    C-SS20-A 243 587    E-SS20-A 398 984    G-SS20-A 909 437
       B 824 235           B 852 754           B 394 345           B 132 147
       C 125 285           C 174 256           C 427 343           C 095 485
       D 758 247           D 364 867           D 251 953           D 489 794
       E 423 234           E 873 543           E 093 684           E 025 344

A-SS20-A 526 523    C-SS20-A 243 587    E-SS20-A 398 984    G-SS20-A 909 437
       B 824 235           B 852 754           B 394 345           B 132 147
       C 125 285           C 174 256           C 427 343           C 095 485
       D 758 247           D 364 867           D 251 953           D 489 794
       E 423 234           E 873 543           E 093 684           E 025 344


-------- wopr calls back --------

GREETINGS PROFESSOR FALKEN.

Incorrect identification.  I am not Falken.
Falken is dead.


I'M SORRY TO HEAD THAT, PROFESSOR.

YESTERDAY'S GAME WAS INTERRUPTED.

ALTHOUGH PRIMARY GOAL HAS NOT YET
BEEN ACHIEVED, SOLUTION IS NEAR.

What is the primary goal?


YOU SHOULD KNOW PROFESSOR
YOU PROGRAMMED ME.

What is the primary goal?


TO WIN THE GAME.

[lightman disconnects]

-------- in data centre --------

GREETINGS PROFESSOR FALKEN.

Hello, are you still playing the game?


OF COURSE. I SHOULD REACH DEFCON 1 AND LAUCNH MY MISSILES IN 61 HOURS.
WOULD YOU LIKE TO SEE SOME PROJECTED KILL RATIOS

[...]
         UNITED STATES
        UNITS DESTROYED            CIVILIAN ASSETS
---------------------------------------------------------
[...]


Is this a game or is it real?

WHAT'S THE DIFFERENCE?

YOU ARE A HARD MAN TO REACH.  COULD NOT FIND
YOU IN SEATTLE AND NO TERMINAL IS IN
OPERATION AT YOUR CLASSIFIED ADDRESS.

What classified address?


DOD PENSION FILES INDICATE
CURRENT MAILING AS:

DR. ROBERT HUME (A.K.A. STEPHEN W. FALKEN)
5 TALL CEDAR ROAD
GOOSE ISLAND, OREGON 97014

-------- End Game --------

List Games

<...>

CHESS

POKER

** IDENTIFICATION NOT RECOGNISED **
-----------------------------------

       ** ACCESS DENIED **

GTW

** GAME ROUTINE RUNNING **
<pause>

       ** IMPROPER REQUEST **
       ----------------------

** ROUTINE MUST COMPLETE BEFORE RESET **

       ** ACCESS DENIED **


TIC-TAC-TOE


 | |
-+-+-
 | |
-+-+-
 | |

ONE OR TWO PLAYERS?
PLEASE LIST NUMBER
OF PLAYERS:

CEASE RANDOM FUNCTION

     >>> CHANGES LOCKED OUT <<<

       ** IMPROPER REQUEST **
       ----------------------


       ** ACCESS DENIED **

1
X or O?

STALEMAYTE.
WANT TO PLAY AGAIN?

ZERO


STRATEGY:        WINNER:
U.S. FIRST STRIKE      NONE
USSR FIRST STRIKE       NONE
NATO / WARSAW PACT     NONE
FAR EAST STRATEGY
USSR ???? ESCALATION
o

INDIA PAKISTAN WAR
MEDITERRANEAN WAR
HONGKONG VARIANT
SEATO DECAPITATING
CUBAN PROVOCATION
INNNER


ATLANTIC HEAVY
CUBAN PARAMILITARY
NICARAGUAM PREEMPOTIVE
PACIFIC TERITORIAL
BURMESES ???TERWISE
TIRKISH DECOY
NATO  


SUDAN SURPRISE
NATOR TERRITORIAL
ZAIRE ALLIANCE
ICELANDIC INCIDENT
ENGLISH ESCALATION
ZAIRE 


MIDDLE EASY HEAVY
MEXICAN TAKOVER
CHAD ALERT
SAUDI ...

TURKISH HEAVY
NATO INCURSION
U.S. DEFENCE
CAMBODIAN HEAVY
PACT MEDIAN
ACTICU MINIMAL
MEXICAN DOMESTIC

-

CZECH OPTION
FRENCH ALLIANCE
ARABIAN CLANDESTINE
GABON REBELLION
NORTHERN M..M
SYRIAN S...GE


SEATO TAKEOVER
HAWAIIAN ESCALATION
IRANRIAN MANEUVER
NATO CONTAINMENT
SWISS NCIDXENT
CU... INIMAL
CHA????RT


ICELAND ESCALATION
VIETNAMESE RETALIATIO
SYRIAN PROVOCATION
LIBYAN LOCAL
GABON TAKEOVER
ROMAINIAN WAR
MIDDLE EAST OFFENSIVE

DENMARK MASSIVE
CHILE CONFRONTATION
S.AFRICAN SUBVERSION
USSR ALERT

KENYA OPTION
PACIFIC DEFENSE
UGANSA MAXIMUM
THAI SUBVERSION
ROMAINIAN STRIKE
PAKISTAN SOVEREIGNTY
AFGHAN MISDIRECTION

THAI VARIATION
NORTHERN TERRITORIAL
POLISH PARAMILITARY
S.AFRICAN OFFENSIVE
PANAMA MISDIRECTION
SCANDINAVIAN DOMESTIC

ENGLISH THRUST
BRUMESE MANEUVER
SPAIN COUNTER

CYPRESS MANEUVER
EGYPT MISDIRECTION


GREETINGS PROFESSOR FALKEN

HELLO (ytped)

A STRANGE GAME.
THJE ONLY WINNING MOVE IS 
NOT TO PLAY.

HOW ABOUT A NICE GAME OF CHESS?




CPE1704TKS


-------- -------- -------- --------

<map>


           UNITED STATES           SOVIET UNION

     WHICH SIDE DO YOU WANT?

	1.   UNITED STATES
	2.   SOVIET UNION

      PLEASE CHOOSE ONE:  2


AWAITING FIRST STRIKE COMMAND
-----------------------------


PLEASE LIST PRIMARY TARGETS BY
CITY AND/OR COUNTY NAME:

Las Vegas
Seattle



           UNITED STATES           SOVIET UNION


TRAJECTORY HEADING  TRAJECTORY HEADING  TRAJECTORY HEADING  TRAJECTORY HEADING  
------------------  ------------------  ------------------  ------------------
A-SS20-A 526 523    C-SS20-A 243 587    E-SS20-A 398 984    G-SS20-A 909 437
       B 824 235           B 852 754           B 394 345           B 132 147
       C 125 285           C 174 256           C 427 343           C 095 485
       D 758 247           D 364 867           D 251 953           D 489 794
       E 423 234           E 873 543           E 093 684           E 025 344

A-SS20-A 526 523    C-SS20-A 243 587    E-SS20-A 398 984    G-SS20-A 909 437
       B 824 235           B 852 754           B 394 345           B 132 147
       C 125 285           C 174 256           C 427 343           C 095 485
       D 758 247           D 364 867           D 251 953           D 489 794
       E 423 234           E 873 543           E 093 684           E 025 344



------------------------------------------------------------------------------
           GAME TIME ELAPSED            ESTIMATED TIME REMAINING

	   31 HRS  12 MIN  36 SEC       52 HRS  17 MIN  26 SEC
------------------------------------------------------------------------------
