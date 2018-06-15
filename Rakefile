require 'rake/clean'
require 'rake_cloudspin'

CLEAN.include('build')
CLEAN.include('work')
CLEAN.include('dist')
CLOBBER.include('vendor')

task :default => [ :plan ]

RakeCloudspin.define_tasks
