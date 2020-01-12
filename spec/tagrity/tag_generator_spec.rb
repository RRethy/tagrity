require 'tagrity/tag_generator'
require 'tagrity/helper'
require 'tagrity/tlogger'

RSpec.describe Tagrity::TagGenerator do
  def delete_tags_comments
    `cat tags | grep -v -E "^!_TAG" > .tags ; mv .tags tags`
  end

  def logger
    logger = Tagrity::Tlogger.instance
    allow(logger)
      .to receive(:info)
    expect(logger)
      .to_not receive(:error)
    allow(logger)
      .to receive(:logf)
      .and_return('')
    logger
  end

  it 'generates tags correctly in a non-git repo' do
    Dir.chdir('./test_files/') do
      git_dir = `git rev-parse --git-dir`.rstrip
      `mv #{git_dir} #{git_dir}.hide`
      config = Tagrity::ConfigFile.instance
      config.reload_local
      `rm -f tags`
      generator = Tagrity::TagGenerator.new(config, logger)
      generator.generate_all
      delete_tags_comments
      `mv #{git_dir}.hide #{git_dir}`
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
      generator = Tagrity::TagGenerator.new(config, logger)
      generator.generate_all
      `rm -rf .git`
      delete_tags_comments
      expect(FileUtils.cmp('./tags', './expected_genall_git_tags'))
        .to eq(true)
    end
  end

  it 'deletes tags for files' do
    Dir.chdir('./test_files/') do
      config = Tagrity::ConfigFile.instance
      config.reload_local
      generator = Tagrity::TagGenerator.new(config, logger)
      generator.generate_all
      generator.delete_files_tags(['foobar.rb', 'foo/foobar.c'])
      delete_tags_comments
      expect(FileUtils.cmp('./tags', './expected_after_delete'))
        .to eq(true)
    end
  end

  it "deleting tagf causes a no-op" do
    Dir.chdir('./test_files/') do
      config = Tagrity::ConfigFile.instance
      config.reload_local
      generator = Tagrity::TagGenerator.new(config, logger)
      generator.generate_all
      `rm -f tags`
      generator.delete_files_tags(['tags', 'foobar.rb', 'foo/foobar.c'])
    end
  end
end
