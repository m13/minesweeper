# Shared configuration of SimpleCov. This is a Ruby script.

SimpleCov.start 'rails' do
  add_filter "/spec/"
end
