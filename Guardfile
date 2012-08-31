guard 'livereload' do
  watch(%r{^(test|dist|docs)\/.+\.(css|js|html)$})
end

guard 'shell' do
  watch(%r{^src\/.*\.coffee$}) { `grunt libs docs` }
  watch(%r{^test\/.*\.coffee$}) { `grunt tests` }
end
