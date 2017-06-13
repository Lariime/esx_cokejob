description 'ESX Extended - CokeJob'

server_script 'server/main.lua'
server_script 'config.lua'

client_script 'config.lua'
client_script 'client/main.lua'

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/pdown.ttf',
	'html/img/keys/enter.png'
}