#!/bin/bash

{
	compteur_valid=0
	compteur_invalid=0
	# Boucle sur chaque fichier map dans le répertoire maps
	for mapfile in maps_test/*; do
		echo "Processing map: $mapfile"
		# Vérifie si le nom du fichier commence par 'b'
		 output=$(timeout --foreground 5s valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=1 --log-file=/dev/null ./cub3D "$mapfile" 2>&1);
		exit_status=$?
		if [ $exit_status -eq 124 ]; then
			echo -e "The program $mapfile was terminated due to a timeout.\n"
			if [[ $(basename "$mapfile") == b* ]]; then
				echo -e "\e[31mtimeout ERROR: $mapfile\e[0m"
				((compteur_invalid++))
			fi
			if [[ $(basename "$mapfile") == v* ]]; then
				echo -e "\e[32mtimeout OK: $mapfile\e[0m"
				((compteur_valid++))
			fi
		else
			echo -e "The program $mapfile was terminated with exit code $exit_status.\n"
			if [[ $(basename "$mapfile") == b* ]]; then
				echo -e "\e[32mProgram exit OK: $mapfile\e[0m"
				((compteur_valid++))
			fi
			if [[ $(basename "$mapfile") == v* ]]; then
				echo -e "\e[32mProgram exit ERROR: $mapfile\e[0m"
				((compteur_invalid++))
			fi
			if [[ $(basename "$mapfile") == g* ]]; then
				echo -e "\e[32mProgram exit ERROR: $mapfile\e[0m"
				((compteur_invalid++))
			fi
		fi
		if [[ $(basename "$mapfile") == b* ]]; then
			# Exécute cub3D avec valgrind, capture la sortie standard et d'erreur
			# Cherche le motif d'erreur spécifique "Error\n \n"
			if echo "$output" | grep -Pzo "Error.*(\n.*\n)?"; then
				# Si le motif d'erreur est trouvé, affiche les erreurs
				echo -e "\e[32mOK: $mapfile\e[0m"
				((compteur_valid++))
			else
				# Si aucune erreur correspondant au motif n'est trouvée et que le nom commence par 'b'
				echo -e "\e[31mERROR: $mapfile\e[0m"
				((compteur_invalid++))
			fi
		fi
		if [[ $(basename "$mapfile") == g* ]]; then
			# Exécute cub3D avec valgrind, capture la sortie standard et d'erreur
			# Cherche le motif d'erreur spécifique "Error\n \n"
			if echo "$output" | grep -Pzo "Error.*(\n.*)?"; then
				echo -e "\e[31mERROR: $mapfile\e[0m"
				((compteur_invalid++))
			else
				# Si aucune erreur correspondant au motif n'est trouvée et que le nom commence par 'b'
				echo -e "\e[32mOK: $mapfile\e[0m"
				((compteur_valid++))
			fi
		fi
		if [[ $(basename "$mapfile") == v* ]]; then
			if echo "$output" | grep -Pzo "Error.*(\n.*\n)?"; then
				echo -e "\e[32mOK: $mapfile\e[0m"
			else
				echo -e "\e[31mERROR: $mapfile\e[0m"
			fi
		fi
	done
	echo -e "\e[32mNumber of valid map: $compteur_valid\e[0m"
	echo -e "\e[31mNumber of invalid map: $compteur_invalid\e[0m"
} 2>&1 | tee outfile.txt

