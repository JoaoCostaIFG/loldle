URL = https://leagueoflegends.fandom.com

champion_list:
	@curl --silent '${URL}/wiki/List_of_champions' | \
		htmlq --attribute href 'table.article-table tbody tr td:first-child div a' | \
		cut -d'/' -f3 >champion_list

champion_info:
	@./fetch_champion_info
