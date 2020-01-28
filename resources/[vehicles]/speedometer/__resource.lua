resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script {
	'client.lua',
	'InteractSound.lua'
}

ui_page('html/index.html')

files({
    'html/index.html',
    'html/sounds/chime.ogg'
})

before_level_meta 'speedometer'
files {
	'stream/speedometer.ytd'
}