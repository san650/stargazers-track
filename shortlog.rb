#!/usr/bin/env ruby

require "json"

def head
  <<-EOT
  <style>
    a {text-decoration:none}
    img {width:35px}
    span {display:none}
    .deleted{border:1px solid red;opacity:0.5}
  </style>
  EOT
end

def header(file)
  title = file.gsub(%r{data/(\d+)-(\d+)-(\d+)-.*}, '\3/\2')

  "<h1>#{title}</h1>"
end

def fragment(user, klass = "")
  <<-EOT
    <a href="#{user[2]}" class="user #{klass}" title="@#{user[0]}">
      <img src="#{user[1]}" alt="#{user[0]}">
      <span>#{user[0]}</span>
    </a>
  EOT
end

user = ARGV[0]
project = ARGV[1]

unless user && project
  puts "Usage: ./shortlog.rb san650 ember-cli-page-object"
  exit 1
end

before = []
current = []
diff = []
deleted = []

puts head

Dir["data/*-#{user}-#{project}.json"].sort.each do |file|
  current = []

  JSON.parse(File.read(file)).each do |user|
    current << [
      user["login"],
      user["avatar_url"],
      user["html_url"]
    ]
  end

  diff = current - before
  deleted = before - current
  before = current

  next unless (diff.any? or deleted.any?)

  # RENDER
  puts header(file)

  diff.each do |user|
    puts fragment(user)
  end

  deleted.each do |user|
    puts fragment(user, "deleted")
  end
end
