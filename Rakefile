require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "."
  t.test_files = FileList['*_test.rb']
  t.verbose = true
end
