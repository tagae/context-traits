guard 'sass',
  :input => '_styles',
  :output => 'styles',
  :style => :compressed

guard 'bundler' do
  watch 'Gemfile'
end

guard 'livereload' do
  watch %r{^_site\/.+\.(css|js|html)$}
end
