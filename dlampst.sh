#!/bin/sh

#=== Inputs/Variables ===#
proccess=${1-none} 
mode=${2-none}

# How work inputs?
# dlampst [proccess] [mode]

#Other variables
php_ini_path="/your_path_to/php.ini" 
mysql_mycnf_path="/your_path_to/my.cnf"
no_restart=0

#=== Functions ===#
syntax_error_print () {
	echo "Invalid syntax, use dlampst [proccess] [mode], where:"
	echo "[proccess]: php or mysql"
	echo "[mode]: on, off or status"
}

if [ $proccess = 'php' ]; then
	
	if [ $mode = 'on' ]; then 		
		sudo sed -i '/^;xdebug/s/^;/''/g' $php_ini_path
		echo "File $php_ini_path was modify"
		echo "$proccess debug is now on"

	elif [ $mode = 'off' ]; then
		sudo sed -i '/^xdebug/s/^/;/g' $php_ini_path
		echo "File $php_ini_path was modify"
		echo "$proccess debug is now off"
	
	elif [ $mode = 'status' ]; then
		if [ "$(cat $php_ini_path | grep '^;xdebug')" != '' ]; then
			echo "$proccess debug is off"
		else
			echo "$proccess debbug is on"
		fi
		no_restart=1

	else
		no_restart=1
		syntax_error_print 		
	fi

	if [ $? -eq 0 -a $no_restart -ne 1 ]; then
		# We need restart apache
        # service apache restart OR
        # systemctl restart apache.service OR
        # Any other command to restart apache
	fi

elif [ $proccess = 'mysql' ]; then
	
	if [ $mode = 'on' ]; then
		sudo sed -i '/^#general_log/s/^#/''/g' $mysql_mycnf_path
		echo "File $mysql_mycnf_path was modify"
		echo "$proccess debug is now on"

	elif [ $mode = 'off' ]; then
		sudo sed -i '/^general_log/s/^/#/g' $mysql_mycnf_path
		echo "File $mysql_mycnf_path was modify"
		echo "$proccess debug is now off"

	elif [ $mode = 'status' ]; then
		if [ "$(cat $mysql_mycnf_path | grep '^#general_log')" != '' ]; then
			echo "$proccess debug is off"
		else
			echo "$proccess debbug is on"
		fi
		no_restart=1

	else
		no_restart=1
		syntax_error_print 	
	fi

	if [ $? -eq 0 -a $no_restart -ne 1 ]; then
		# We need restart mysql
        # service mysql restart OR
        # systemctl restart mysql.service OR
        # Any other command to restart mysql
	fi

else
	syntax_error_print
fi
