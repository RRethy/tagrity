require 'tagrity/tag_generator'
require 'tagrity/helper'

RSpec.describe Tagrity::TagGenerator do
  it 'generates tags correctly in a non-git repo' do
    Dir.chdir('./test_files/') do
      config = Tagrity::ConfigFile.instance
      config.reload_local
      `rm -f tags`
      generator = Tagrity::TagGenerator.new(config)
      generator.generate_all
      `cat tags | grep -v -E "^!_TAG" > .tags ; mv .tags tags`
      expect(FileUtils.cmp('./tags', './expected_genall_nongit_tags'))
        .to eq(true)
    end
  end

  it 'generates tags correctly in a git repo' do
    Dir.chdir('./test_files/') do
      config = Tagrity::ConfigFile.instance
      config.reload_local
      `git init`
      `git add .`
      `rm -f tags`
      generator = Tagrity::TagGenerator.new(config)
      generator.generate_all
      `rm -rf .git`
      `cat tags | grep -v -E "^!_TAG" > .tags ; mv .tags tags`
      expect(FileUtils.cmp('./tags', './expected_genall_git_tags'))
        .to eq(true)
    end
  end

  it 'deletes tags for files' do
    Dir.chdir('./test_files/') do
      config = Tagrity::ConfigFile.instance
      config.reload_local
      generator = Tagrity::TagGenerator.new(config)
      generator.generate_all
      generator.delete_files_tags(['foobar.rb', 'foo/foobar.c'])
      `cat tags | grep -v -E "^!_TAG" > .tags ; mv .tags tags`
      expect(FileUtils.cmp('./tags', './expected_after_delete'))
        .to eq(true)
    end
  end
end
