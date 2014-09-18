# encoding: utf-8

require 'rexml/document'
require 'sqlite3'

QUERY = ARGV[0].to_s.strip

doc = REXML::Document.new('<?xml version="1.0"?>')

begin

	db = SQLite3::Database.open "kanji1006.sqlite3"

	root = doc.add_element('items')

	db.execute "select * from kanji1006 where title like '%#{QUERY}%' order by id asc" do |row|
		item = root.add_element('item')
		title = item.add_element('title')
		title.text = row[1]
		subtitle = item.add_element('subtitle').text = row[2]
	end

rescue SQLite3::Exception => e

	puts "Exception occured"
	puts e

ensure
	db.close if db
end

puts doc.to_s