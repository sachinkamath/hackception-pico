#!/bin/sh

clear

## Making all the necessary files required!
## $1 = categoryname  $2 = shortname

makeall() {
	mkdir "$1/$2";
	mkdir "$1/$2/grader";
	touch "$1/$2/grader/grader.py";
	touch "$1/$2/problem.json";
	jsonpath="$1/$2/problem.json";

}

makeproblem() {
	echo $jsonpath;
}

##Pretty Interactive Window

echo "\n\nQuestion Auto-Gen Script by Zero\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n\n";
echo "Select Category : \n~~~~~~~~~~~~~~~~\n\n\n";
echo " 1. Web \n 2. Crypto \n 3. General \n 4. Forensics \n 5. Add Category";
printf "\n\n Enter Choice : ";
read choice;

case "$choice" in 
	1)
		category="web"
		if [ ! -d "$category" ]; then
			mkdir web;
		fi

		printf "\n\nEnter a shortname for the question : ";
		read shortname;
		makeall $category $shortname;

		printf "\n\nEnter a fancy name for the program : ";
		read name;
		printf "\n\n Enter points for the question : ";
		read score;
		printf "\n\n Enter the description  : ";
		read description;
		printf "\n\n Hint (Links to static files) : ";
		read hint;

		makeproblem



esac

