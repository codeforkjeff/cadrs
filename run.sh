#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	: # TODO
elif [[ "$OSTYPE" == "darwin"* ]]; then
	: # TODO
elif [[ "$OSTYPE" == "cygwin" ]]; then
	: # TODO
elif [[ "$OSTYPE" == "msys" ]]; then
	PATH=$PATH:"/c/Program Files/R/R-3.4.4/bin/"
	R_EXEC="Rscript.exe"
elif [[ "$OSTYPE" == "win32" ]]; then
	PATH=$PATH:"/c/Program Files/R/R-3.4.4/bin/"
	R_EXEC="Rscript.exe"
else
	: # TODO
fi

# create basic training data
#$R_EXEC R/cadr_training_data.R


# create training data for Renton
$R_EXEC preprocess/training_data_RSD.R
