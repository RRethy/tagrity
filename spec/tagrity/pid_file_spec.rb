require 'tagrity/pid_file'
require 'tagrity/process_helper'

RSpec.describe Tagrity::PidFile do
  it "writes the correct file" do
    pid_file = Tagrity::PidFile.new('foo/bar/baz', '1876')
    expect(File)
      .to receive(:write)
      .with("#{Tagrity::PidFile::RUN_DIR}/baz.1876.pid", "foo/bar/baz")

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

    Tagrity::PidFile.delete('/foo')
  end
end
