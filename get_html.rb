# encoding=utf-8 
require 'open-uri'





unless Dir.exists?("data")
	Dir.mkdir("data")
end


top_url = "http://web.dgpa.gov.tw/lp.asp?CtNode=403&CtUnit=180&BaseDSD=7&mp=7&nowPage=1&pagesize=300"
top_path = "http://web.dgpa.gov.tw/"
tmp = open(top_url)
mainpage = tmp.read

pat1 = /<li><a href="(ct.asp\?xItem=\d+&ctNode=403&mp=7)" title="[\u4e00-\u9a05\d\s\w\(\)="]+">[\u4e00-\u9a05\d\s]+<\/a><span class="date">(\d+).(\d+).(\d+)<\/span><\/li>/
pat2 = /<li><a href="([\w\d\.\/]+)" title="[\u4e00-\u9a05\d\s\w\(\)]+">[\u4e00-\u9a05\d\s\w\(\)]+<\/a><span class="date">(\d+).(\d+).(\d+)<\/span><\/li>/
pat3 = /(public\/Attachment\/\d+\.html)/

pages = mainpage.scan(pat1).to_a
links = mainpage.scan(pat2).to_a

for page in pages
	page_url = top_path + page[0].to_s
	puts "visiting " + page_url
	tmp = open(page_url).read
	html_url = tmp.scan(pat3)
	if html_url.size > 0
		html_url = html_url[0][0].to_s
		puts "found " + top_path+html_url
		puts "downloading " + html_url
		html = open(top_path+html_url).read
		year = (page[1].to_i + 1911).to_s
		mon = page[2].to_s
		day = page[3].to_s

		File.open("data/#{year}#{mon}#{day}.html", "w+") do |i|
    		i.write(html)
		end
	end
end




for link in links
	html_url = top_path + link[0].to_s
	puts "downloading " + html_url
	html = open(html_url).read
	
	year = (link[1].to_i + 1911).to_s
	mon = link[2].to_s
	day = link[3].to_s

	File.open("data/#{year}#{mon}#{day}.html", "w+") do |i|
    	i.write(html)
	end
end





