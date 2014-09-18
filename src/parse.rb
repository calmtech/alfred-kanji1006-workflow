# encoding: utf-8

require 'uri'
require 'nokogiri'

sqlite3_rows = []

File::open('/Users/masaya/Workspace/alfred-1006kanji-workflow/src/src_html.html') do |f|
	doc = Nokogiri::HTML(f)
	id = 1
	school_year_number = 1
	sqlite3_rows = []
	doc.search('table table').each do |table|
		school_year = table.children.first.content

		table.search('tr[valign=TOP]').each do |tr|
			tr.children.each do |td|
				
				next if td.children.first.content == "　"

				title = td.children.first.content
				title = title + ' 【' + td.children.last.inner_html.split('<br>').join('・') + '】' if title != nil
				
				sqlite3_rows << "#{id}|#{title}|#{school_year}|#{school_year_number}"
				id += 1
				
			end
		end
		school_year_number += 1
	end
end

File.open('sqlite3_rows.txt', 'w') do |f|
	sqlite3_rows.each do |row|
		f.puts row
	end
end