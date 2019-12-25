require 'tagrity/tag_generator'
require 'tagrity/helper'

RSpec.describe Tagrity::TagGenerator do
  it 'generates tags correctly' do
    files = ['foo.rb', 'bar.rb', 'baz.c', 'vendor/foo.rb', './vendor/foo.rb']
  end
end
