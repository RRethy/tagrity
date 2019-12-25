require 'tagrity/helper'

RSpec.describe Tagrity::Helper do
  it 'checks if command is executable' do
    { 'ls' => true, 'foobarbazhopefullynotacommand' => false }.each do |cmd, exists|
      expect(Tagrity::Helper.executable?(cmd))
        .to eq(exists)
    end
  end

  it 'sends HUP to pid' do
    # TODO
  end

  it 'checks if pid is alive' do
    { 123 => false, Process.pid => true }.each do |pid, alive|
      expect(Tagrity::Helper.alive?(pid))
        .to eq(alive)
    end
  end

  it 'checks if dir is a git dir' do
    { '.' => true, '..' => false }.each do |dir, git_dir|
      Dir.chdir(File.expand_path(dir)) do |path|
        expect(Tagrity::Helper.git_dir?)
          .to eq(git_dir)
      end
    end
  end

  it 'checks if file is ignored by git' do
    { 'README.md' => false, 'tags' => true }.each do |fname, ignored|
      expect(Tagrity::Helper.file_ignored?(fname))
        .to eq(ignored)
    end

    untracked_fname = 'foobar'
    FileUtils.touch(untracked_fname)
    expect(Tagrity::Helper.file_ignored?(untracked_fname))
      .to eq(false)
    File.delete(untracked_fname)
  end

  it 'check if file is tracked by git' do
    { 'README.md' => true, 'tags' => false }.each do |fname, tracked|
      expect(Tagrity::Helper.file_tracked?(fname))
        .to eq(tracked)
    end

    untracked_fname = 'foobar'
    FileUtils.touch(untracked_fname)
    expect(Tagrity::Helper.file_tracked?(untracked_fname))
      .to eq(false)
    File.delete(untracked_fname)
  end
end
