
require 'spec_helper'


users=[
    {'name' => 'vagrant', 'uid' => 1000},
    {'name' => 'root', 'uid' => 0},
    {'name' => 'ubuntu', 'uid' => 1001}
]

groups=[
    {'name' => 'vagrant', 'gid' => 1000},
    {'name' => 'root', 'gid' => 0},
    {'name' => 'ubuntu', 'gid' => 1001}

]

users.each do |user|
  describe user(user['name']) do
    it { should exist }
  end
end

groups.each do |group|
  describe group(group['name']) do
    it { should exist }
  end
end
