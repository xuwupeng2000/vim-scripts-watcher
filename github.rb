require "github_api"

class Script < Struct.new(:name, :full_name, :url, :watchers)
end
username = ARGV[0]
password = ARGV[1]

puts username + ":" + password
@scripts = []

github = Github.new :login => username, :password => password
res = github.repos.list user:'vim-scripts', per_page: 100, page: 1 

hashes = res.body
hashes.each do |hash|
  script = Script.new(name = hash["name"], full_name = hash["full_name"], url = hash["url"], watchers = hash["watchers"] )
  @scripts << script
end

while res.has_next_page?
  res = res.next_page
  hashes = res.body
  hashes.each do |hash|
    script = Script.new(name = hash["name"], full_name = hash["full_name"], url = hash["url"], watchers = hash["watchers"] )
    @scripts << script
  end
end

@list = @scripts.sort!{|s1,s2| s1.watchers <=> s2.watchers}.reverse!

File.open('scripts_list.txt', 'w') do |line|
  @list.each do |e|
    line.puts e.name + "   HAS   " + e.watchers.to_s + " of watchers you can find it here: @   " + e.url
  end
end
