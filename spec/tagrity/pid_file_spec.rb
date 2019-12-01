require 'tagrity/pid_file'
require 'tagrity/process_helper'

RSpec.describe Tagrity::PidFile do
  it "writes the correct file" do
    pid_file = Tagrity::PidFile.new('foo/bar/baz', '1876')
    expect(File)
      .to receive(:write)
      .with("#{Tagrity::PidFile::RUN_DIR}/baz.1876.pid", "foo/bar/baz")
    expect(Tagrity::PidFile)
      .to receive(:run_dir)
      .and_return(Tagrity::PidFile::RUN_DIR)

    Tagrity::PidFile.write(pid_file)
  end

  it "deletes all pid files for the dir" do
    allow(Dir)
      .to receive(:glob)
      .and_return(['foo.123.pid', 'foo.124.pid', 'foo.125.pid'])
    allow(File)
      .to receive(:read)
      .exactly(3).times
      .and_return('/foo', '/foo', '/bar')

    expect(File)
      .to receive(:delete)
      .with('foo.123.pid')
    expect(File)
      .to receive(:delete)
      .with('foo.124.pid')
    expect(Tagrity::ProcessHelper)
      .to receive(:kill)
      .with(123)
    expect(Tagrity::ProcessHelper)
      .to receive(:kill)
      .with(124)
    expect(Tagrity::PidFile)
      .to receive(:run_dir)
      .and_return(Tagrity::PidFile::RUN_DIR)

    Tagrity::PidFile.delete('/foo')
  end

  it "lists all alive dirs when none are specified to status" do
    allow(Dir)
      .to receive(:glob)
      .and_return(['/foo.123.pid', '/foo.124.pid', '/foo.125.pid', '/bar.126.pid', '/foo.127.pid'])
    allow(File)
      .to receive(:read)
      .exactly(4).times
      .and_return('/foo', '/foo/bar', '/foo', '/bar', '/foo')
    allow(Tagrity::ProcessHelper)
      .to receive(:alive?)
      .exactly(5).times
      .and_return(true, true, true, true, false)

    expect(File)
      .to receive(:delete)
      .with('/foo.127.pid')
    expect(Tagrity::PidFile.status)
      .to eq([
        Tagrity::PidFile.new('/foo', 123),
        Tagrity::PidFile.new('/foo/bar', 124),
        Tagrity::PidFile.new('/foo', 125),
        Tagrity::PidFile.new('/bar', 126),
    ])
  end

  it "lists only matching directories to status" do
    allow(Dir)
      .to receive(:glob)
      .and_return(['/foo.123.pid', '/foo.124.pid', '/foo.125.pid', '/bar.126.pid', '/foo.127.pid'])
    allow(File)
      .to receive(:read)
      .exactly(4).times
      .and_return('/foo', '/foo/bar', '/foo', '/bar', '/foo')
    allow(Tagrity::ProcessHelper)
      .to receive(:alive?)
      .exactly(5).times
      .and_return(true, true, false)
    allow(Tagrity::PidFile)
      .to receive(:is_same_dirs)
      .and_return(true, false, true, false, true)

    expect(File)
      .to receive(:delete)
      .with('/foo.127.pid')
    expect(Tagrity::PidFile.status(dir: '/foo'))
      .to eq([
        Tagrity::PidFile.new('/foo', 123),
        Tagrity::PidFile.new('/foo', 125),
    ])
  end
end
