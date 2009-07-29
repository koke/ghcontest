require 'common'

tests = File.read('test.txt')
(users, repos) = get_users_repos
usermap = read_outfile('usermap.txt')

guesses = {}

time = Time.now()

tests = tests.split("\n")
total = tests.size
current = 0

tests.each do |uid|
  uid = uid.strip.to_i
  next if !usermap[uid]
  
  common = {}

  usermap[uid].each do |compid|
    next if compid == uid
    ratio = 1 + (users[uid].size - users[compid].size).abs
    users[compid].each do |repoid|
      common[repoid] ||= 0
      common[repoid] += 1.0 / ratio
    end
  end

  friends = common.sort { |a, b| a[1] <=> b[1] }.reverse[0, 10]  
  friends = friends.map { |a| a[0] }
  guesses[uid] = friends
  
  current += 1
  puts "#{current}/#{total}: #{uid}"
end

puts Time.now() - time

write_outfile(guesses)