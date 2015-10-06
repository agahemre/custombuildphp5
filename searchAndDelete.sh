#!/bin/bash

# usage ./searchAndDelete.s


BASE_PATH=$1
SEARCH_DIR=$2

recursive_delete()
{	
	for dir in *;
	do
		if [ -d $dir ]; then
			(cd $dir; 
			recursive_delete)
		fi
		
		# execute anything
		rm -rf $SEARCH_DIR
	done
}

# first we goto related directory where we start to search //Ok...
(cd $BASE_PATH; 
recursive_delete)
