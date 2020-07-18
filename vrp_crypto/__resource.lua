resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
    "@vrp/lib/utils.lua",
    "real_crypto.lua",
    'sv_vrp.lua',
}

file 'client.lua'

client_scripts {
  "@vrp/lib/utils.lua",
  "cl_vrp.lua"
}

client_scripts {
  "cl_instructionals.lua",
  "include.lua"
}
