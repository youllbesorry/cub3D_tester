#!/bin/bash

{
	compteur_valid=0
	compteur_invalid=0
	# Boucle sur chaque fichier map dans le répertoire maps
	for mapfile in maps_test/*; do
		echo "Traitement de la map: $mapfile"
		# Vérifie si le nom du fichier commence par 'b'
		 output=$(timeout --foreground 5s valgrind --leak-check=full --show-leak-kinds=all --error-exitcode=1 --log-file=/dev/null ./cub3D "$mapfile" 2>&1);
		exit_status=$?
		if [ $exit_status -eq 124 ]; then
			echo -e "Le programme $mapfile a été terminé en raison d'un dépassement de temps (timeout).\n"
			if [[ $(basename "$mapfile") == b* ]]; then
				# echo -e "\n"
				echo -e "\e[31mtimeout ERROR: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_invalid++))
			fi
			if [[ $(basename "$mapfile") == v* ]]; then
				# echo -e "\n"
				echo -e "\e[32mtimeout OK: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_valid++))
			fi
		else
			echo -e "Le programme $mapfile a été terminé avec le code de sortie $exit_status.\n"
			if [[ $(basename "$mapfile") == b* ]]; then
				# echo -e "\n"
				echo -e "\e[32mProgramme exit OK: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_valid++))
			fi
			if [[ $(basename "$mapfile") == v* ]]; then
				# echo -e "\n"
				echo -e "\e[32mProgramme exit ERROR: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_invalid++))
			fi
			if [[ $(basename "$mapfile") == g* ]]; then
				# echo -e "\n"
				echo -e "\e[32mProgramme exit ERROR: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_invalid++))
			fi
		fi
		if [[ $(basename "$mapfile") == b* ]]; then
			# Exécute cub3D avec valgrind, capture la sortie standard et d'erreur
			# Cherche le motif d'erreur spécifique "Error\n \n"
			if echo "$output" | grep -Pzo "Error.*(\n.*\n)?"; then
				# Si le motif d'erreur est trouvé, affiche les erreurs
				# echo -e "\n"
				echo -e "\e[32mOK: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_valid++))
			else
				# Si aucune erreur correspondant au motif n'est trouvée et que le nom commence par 'b'
				# echo -e "\n"
				echo -e "\e[31mERROR: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_invalid++))
			fi
		fi
		if [[ $(basename "$mapfile") == g* ]]; then
			# Exécute cub3D avec valgrind, capture la sortie standard et d'erreur
			# Cherche le motif d'erreur spécifique "Error\n \n"
			if echo "$output" | grep -Pzo "Error.*(\n.*)?"; then
				# echo -e "\n"
				echo -e "\e[31mERROR: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_invalid++))
			else
				# Si aucune erreur correspondant au motif n'est trouvée et que le nom commence par 'b'
				# echo -e "\n"
				echo -e "\e[32mOK: $mapfile\e[0m"
				# echo -e "\n"
				((compteur_valid++))
			fi
		fi
		if [[ $(basename "$mapfile") == v* ]]; then
			if echo "$output" | grep -Pzo "Error.*(\n.*\n)?"; then
				# echo -e "\n"
				echo -e "\e[32mOK: $mapfile\e[0m"
				# echo -e "\n"
			else
				# echo -e ZzzZ"\n"
				echo -e "\e[31mERROR: $mapfile\e[0m"
				# echo -e "\n"
			fi
		fi
	done
	echo -e "\e[32mNombre de maps valides: $compteur_valid\e[0m"
	echo -e "\e[31mNombre de maps invalides: $compteur_invalid\e[0m"
} 2>&1 | tee outfile.txt

