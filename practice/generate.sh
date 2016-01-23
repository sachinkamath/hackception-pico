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
	probfolfer="$1/$2"
	probgrader="$1/$2/grader.py"
	actualgraderpath="$1/$2/grader/grader.py"
	category="$1"

}

makeproblem() {

	#problem.json creation
	echo "{\"name\":\"$1\"," >> $jsonpath;
	echo "\"score\":$2," >> $jsonpath;
	echo "\"category\":\"$category\"," >> $jsonpath;
	echo "\"grader\":\"$probgrader\"," >> $jsonpath;
	echo "\"description\":\"$3\"," >> $jsonpath;
	echo "\"threshold\":0," >> $jsonpath;
	echo "\"weightmap\":{}," >> $jsonpath;
	echo "\"hint\":\"$4\"}" >> $jsonpath;

	#grader.py creation

	echo "def grade(arg,key):" >> $actualgraderpath;
	echo "\tif \"$5\" in key:">> $actualgraderpath;
	echo "\t\treturn True, \"Correct Answer!\"">>$actualgraderpath;
	echo "\telse:">>$actualgraderpath;
	echo "\t\treturn False,\"Not Quite Right. Try again.\"" >>$actualgraderpath;



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

		printf "\n\n Enter a shortname for the question : ";
		read shortname;
		makeall $category $shortname;

		printf "\n\n Enter a fancy name for the program : ";
		read name;
		printf "\n\n Enter points for the question : ";
		read score;
		printf "\n\n Enter the description  : ";
		read description;
		printf "\n\n Hint (Links to static files) : ";
		read hint;
		printf "\n\nEnter the md5 flag for the question : ";
		read flag;
		makeproblem "$name" "$score" "$description" "$hint" "$flag";



esac

