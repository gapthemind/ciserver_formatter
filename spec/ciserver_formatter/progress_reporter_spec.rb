require 'spec_helper'

module CiserverFormatter
  describe ProgressReporter do
    let(:output_file) { double(:file) }
    let(:progress_reporter) { ProgressReporter.new(output_file) }

    it "Reports the status of the formatter" do
      expected_output = """branch:branch_name
test_session_status:Pass
percentage_run:35
failed_count:0
pending_count:0
passed_count:35
example_count:100
      """

      formatter = double(:formatter)
      formatter.stub(status: :pass, percentage: 35, failed_count: 0,
                     pending_count: 0, passed_count: 35, example_count: 100,
                     branch: "branch_name")

      opened_file = double(:opened_file)
      File.should_receive(:open).with(output_file, 'w').and_yield(opened_file)
      opened_file.should_receive(:write).with(expected_output)
      progress_reporter.report(formatter)
    end
  end

end
