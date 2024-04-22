#!/bin/bash
# Used to set a 'grapple point' to quickly navigate from one file to another 
# and go back. Properly overkill, but a fun exercise in shell programming
# and the Linux environment

# two commands:
# -l or --latch: sets a `latch point` that can be used to return to when moving
# -p or --pull: returns user to directory set in --latch command
# -h or --help: prints a help menu

MAIN_ARG=$1
OPT_ARG=$2

if [ -z "$MAIN_ARG" ] || 
	[ "$MAIN_ARG" -eq "-h" ] || 
	[ "$MAIN_ARG" -eq "--help" ]; 
then
	echo "Latch.sh: minimize '[c]hange [d]irectory' calls"
	echo "Saves the latched 'pwd' call to a file and uses that to change the"
	echo "directory back."
	echo ""
	echo "Can be executed by calling this script with 'source' or '.'"
	echo ""
	echo "Valid arguments:"
	echo "-l or --latch: sets latch point/checkpoint to return to"
	echo "-p or --pull: return to the latch point set in a previous --latch call"	
	echo ""
	echo "Options:"
	echo "-l | --latch:"
	echo "   -r | --replace: replaces/overwrites the old latched directory"
	echo "-p | --pull:"
	echo "   -k | --keep: do not delete or clear the previously latched directory"
	exit
fi

case $MAIN_ARG in
	"-l" | "--latch")
		if [ "$OPT_ARG" -eq "-r" ] || [ "$OPT_ARG" -eq "--replace" ]; then
				
		echo `pwd` > ./.latched_dir
		echo "Latched to $(pwd)"
	;;
	"-p" | "--pull")
		# No old directory to return to
		if ! test -f ./.latched_dir; then
			echo "No previous directory is set"
			exit
		fi
		
		LATCHED_DIR=`cat ./.latched_dir`
		if [ -z "$LATCHED_DIR" ]; then
			echo "Cannot change to a null directory"
			exit
		fi

		# determine if directory exists
		if ! test -d $LATCHED_DIR; then
			echo "Directory no longer exists"
			exit
		fi

		
		cd $LATCHED_DIR
	;;
	*)
		echo "Not a supported argument. Use -h or --help to print options"
		exit
	;;
esac
