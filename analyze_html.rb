# encoding=utf-8 
require "json"

system("ls data/ > files.lst")


files = open("files.lst").read.split

pat1 = /charset=[\w\-]+">/
pat2 = /<td width="13%" align="center" valign="middle"><font size="2">([\u4e00-\u9a05]+)<\/font><\/td>\s+<td width="70%" align="left" valign="middle"><font size="2">([\u4e00-\u9a05\u3002\u3001]+)<\/font><\/td>/i
pat3 = /<font[\s\w=#\d'"]+>([\u4e00-\u9a05\u9ad8]+)<\/font><\/td>\s*<td[\s\w#'"=%]+><font[\s\w'"=#\d]+>([\u4e00-\u9a05\u9ad8\u3002\u3001\uff1a:\s]+)\s*<\/font>/i

data = {}

for file in files
	puts "in " + file
	html = open("data/"+file).read
	# html = html.encode("utf-8","big5")
	# html = html.encoding("utf-8")
	begin
		table = html.scan(pat3).to_a
	rescue
		html = html.encode("utf-8","big5")
		table = html.scan(pat3).to_a
	end
	data[file[0..7]] = table
end

puts data

open("data.json", 'w+') do |f|
	f.write(data.to_json)
end
