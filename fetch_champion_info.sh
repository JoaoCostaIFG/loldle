#!/bin/sh

URL="https://leagueoflegends.fandom.com"

fetchChamp() {
  champ="$@"
	echo "$champ" | grep -q '^Nunu' && champ="Nunu"

	champLolPage="$(curl --silent "${URL}/wiki/${champ}/LoL")"
	# release
	release="$(echo "$champLolPage" | htmlq --text '#infobox-champion-container div[data-source=release] div a' | cut -d'-' -f1)"
	# lanes
	lanes="$(echo "$champLolPage" | htmlq --text '#infobox-champion-container div[data-source=position] div span :nth-child(2)' | tr "\n" ' ')"
	# resource
	resource="$(echo "$champLolPage" | htmlq --text '#infobox-champion-container div[data-source=resource] span:first-child :nth-child(2)' | tr -d ' ' | head -1)"
	# range
	range="$(echo "$champLolPage" | htmlq --text '#infobox-champion-container div[data-source=rangetype] span:first-child' | tr -d ' ')"

	champPage="$(curl --silent "${URL}/wiki/${champ}")"
	# species
	species="$(echo "$champPage" | htmlq --text 'aside div[data-source=species] div a' | tr "\n" " ")"
	# regions
	regions="$(echo "$champPage" | htmlq --text 'aside div[data-source=region] div span span a' | tr "\n" " ")"
	# gender
	pronouns="$(echo "$champPage" | htmlq --text 'aside div[data-source=pronoun] div')"
	if [ "$champ" = "Kindred" ]; then
		gender="Other"
	elif [ "$champ" = "Malphite" ]; then
		gender="Male"
	elif echo "$pronouns" | grep -q '^He'; then
		gender="Male"
	elif echo "$pronouns" | grep -q '^She'; then
		gender="Female"
	elif echo "$pronouns" | grep -q '^They'; then
		gender="Other"
	else
		gender="Other"
	fi

	champJson="{
	\"name\": \"$champ\",
	\"release\": \"$release\",
	\"lanes\": $(echo $lanes | awk '{printf "["; for (i=1; i<NF; i++) printf "\"%s\", ", $i; printf "\"%s\"]", $NF}'),
	\"resource\": \"$resource\",
	\"range\": \"$range\",
	\"species\": $(echo $species | awk '{printf "["; for (i=1; i<NF; i++) printf "\"%s\", ", $i; printf "\"%s\"]", $NF}'),
	\"regions\": $(echo $regions | awk '{printf "["; for (i=1; i<NF; i++) printf "\"%s\", ", $i; printf "\"%s\"]", $NF}'),
	\"gender\": \"$gender\"
},"
	echo "$champJson"
}

if [ $# -gt 0 ]; then
	fetchChamp "$@"
else
	curl --silent "${URL}/wiki/List_of_champions" |
		htmlq --attribute href 'table.article-table tbody tr td:first-child div a' |
		cut -d'/' -f3 >champion_list

	out="["
	while read -r champ; do
		champJson="$(fetchChamp "$champ")"
		out="${out}
${champJson}"
	done <"champion_list"
	out="${out}
  ]"

	echo "$out"
fi
