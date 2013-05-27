require 'spec_helper'

describe CiserverFormatter::StatusReporter do
  let(:formatter) { CiserverFormatter::CiserverFormatter.new(double(:string_io)) }
  let(:output_file) { double(:file) }
  let(:status_reporter) { CiserverFormatter::StatusReporter.new(output_file) }

  describe "report_start" do
    it "sets the status to testing" do
      opened_file = double(:opened_file)
      opened_file.should_receive(:write).with("Testing")
      File.should_receive(:open).with(output_file, 'w').and_yield(opened_file)
      status_reporter.start
    end
  end

  describe "report finish" do
    it "sets the status to the formatter status" do
      formatter.should_receive(:status).and_return(:pass)
      opened_file = double(:opened_file)
      opened_file.should_receive(:write).with(:Pass)
      File.should_receive(:open).with(output_file, 'w').and_yield(opened_file)
      status_reporter.finish(formatter)
    end
  end
end
