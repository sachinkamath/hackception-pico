#!/bin/sh


#For a clean beginning.
clear

#Makes the master directory (category) if it does not exist
makemasterdir() {
	if [ ! -d "$1" ]; then
			mkdir "$1";
		fi
}


#########################################################################################################
#				getdetails()																			#
#				Arguments 	: $category , $score, $description, $hint, $key 							#
#				Description : Fills the problem.json and grader.py files with the problem variables.	#
#				Functioning : Creates the json required for the API and creates the API grader.			#
#########################################################################################################
makeproblem() {
	#problem.json creation
	echo "{\"name\":\"$1\"," >> $jsonpath;
	echo "\"score\":$2," >> $jsonpath;
	echo "\"category\":\"$webcategory\"," >> $jsonpath;
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


#########################################################################################################
#				getdetails()																			#
#				Arguments 	: $category 																#
#				Description : Takes the inputs required for question creation interactively.			#
#				Functioning : Gets the details required for problem.json and grader.py creation			#
#########################################################################################################
getdetails() {
	printf "\n\n Enter a shortname for the question : ";
		read shortname;
		makeall $1 $shortname;      #$1 is the webcategory

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

}

#################################################################################################################################
#				makeall()																										#
#				Arguments 	: $category $shortname																				#
#				Description : Takes the input values for the folder name and creates the recommended files and folders			#
#				Functioning : uses touch and mkdir commands to make the files and folders required for the questions.			#
#################################################################################################################################

makeall() {
	mkdir "$1/$2";              #$1 is the category name and $2 is the shortname
	mkdir "$1/$2/grader";
	touch "$1/$2/grader/grader.py";
	echo "\n\n**[Debug Info] Grader created."
	touch "$1/$2/problem.json";
	echo "\n\n**[Debug Info] Problem.json created."
	jsonpath="$1/$2/problem.json";
	probfolfer="$1/$2"
	probgrader="$1/$2/grader.py"				  #######################################################################################
	actualgraderpath="$1/$2/grader/grader.py"     # According to documentation, the config should ignore the /grader/ from the path.	#
	category="$1"								  # actualgraderpath was created for proper pathfinding of the literal grader.py path   #
}												  #######################################################################################



##Pretty Interactive Window

echo "\n\nQuestion Auto-Gen Script by Zero\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n\n";
echo "Select Category : \n~~~~~~~~~~~~~~~~\n\n\n";
echo " 1. Web \n 2. Crypto \n 3. Trivia \n 4. Forensics \n 5. Add Category \n 6. Compile Problems";
printf "\n\n Enter Choice : ";
read choice;

case "$choice" in 
	1)
		category="web"
		makemasterdir "$category";
		webcategory="Web Exploitation";
		echo "\n\n**[Debug Info] Directory $category created successfully."
		getdetails "$category";
	;;

	2)
		category="web"
		makemasterdir "$category";
		webcategory="Cryptography";
		echo "\n\n**[Debug Info] Directory $category created successfully."
		getdetails "$category";
	;;

	3)
		category="trivia"
		makemasterdir "$category";
		webcategory="General - Trivia";
		echo "\n\n**[Debug Info] Directory $category created successfully."
		getdetails "$category";
	;;	

	4)
		category="forensics"
		makemasterdir "$category";
		webcategory="Forensics & Network";
		echo "\n\n**[Debug Info] Directory $category created successfully."
		getdetails "$category";
	;;

	5)
		printf "\n\n Enter the category name (one word) : ";
		read category;
		printf "\n\n Enter the web interface description : ";
		read webcategory;
		makemasterdir "$category";
		echo "\n\n**[Debug Info] Directory $category created successfully."
		getdetails "$category";
	;;

	6)
		printf "\n\n ***Please wait. Calling the API function ..  *** \n\n";
		eval "python3 ~/vagrant/api/api_manager.py -v problems load ~/vagrant/practice/ ~/vagrant/api/graders/ ~/vagrant/problem_static/";

		echo "\n\n*** Creating instances of the problem in the API .. ***\n\n";
		`python3 ~/vagrant/api/api_manager.py autogen build 100`;

		echo "*** Recompiling the assets and restarting nginx ***";
		devploy;
esac

