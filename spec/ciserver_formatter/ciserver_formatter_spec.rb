require 'spec_helper'

module CiserverFormatter
  describe CiserverFormatter do
    let(:output) { double(:string_io).as_null_object }
    let(:formatter) { CiserverFormatter.new(output) }
    let(:example) { double(:example) }
    let(:example_group) { double(:example_group) }

    before(:each) do
      # Ignore progress report
      FileResolver.stub(progress_output_file: nil)
      ProgressReporter.stub(:new).with(nil).and_return(double(:reporter).as_null_object)
    end

    describe "initialize" do
      it "should start as passed" do
        formatter.status.should be :pass
      end

      it "should start with no examples passed" do
        formatter.passed_count.should be 0
      end

      it "should start with no examples failed" do
        formatter.failed_count.should be 0
      end

      it "should start with no examples pending" do
        formatter.pending_count.should be 0
      end
    end

    describe "example group started" do
      it "should output the description" do
        example_group.stub(description: "The example group description")
        output.should_receive(:puts).with("The example group description")
        formatter.example_group_started(example_group)
      end

      it "should increase indentation" do
        example_group.stub(description: "")
        formatter.example_group_started(example_group)

        example.stub(description: "The example description")
        output.should_receive(:puts).with("  The example description")
        formatter.example_group_started(example)
      end
    end

    describe "example group finished" do
      it "should decrease indentation" do
        example_group.stub(description: "")
        formatter.example_group_started(example_group)
        formatter.example_group_finished(example_group)

        example.stub(description: "The example description")
        output.should_receive(:puts).with("The example description")
        formatter.example_group_started(example)
      end
    end

    describe "example passed" do
      it "should increase the number of passed tests" do
        example.stub(description: "The example description")
        formatter.example_passed(example)
        formatter.passed_count.should be 1
      end

      it "should output the passed example description" do
        example.stub(description: "The example description")
        output.should_receive(:puts).with("The example description")
        formatter.example_passed(example)
      end
    end

    describe "example failed" do
      it "should increase the number of failed tests" do
        example.stub(description: "The example description")
        formatter.example_failed(example)
        formatter.failed_count.should be 1
      end

      it "should output the failed example description" do
        example.stub(description: "The example description")
        output.should_receive(:puts).with("The example description")
        formatter.example_failed(example)
      end

      it "should change status to failed" do
        example.stub(description: "The example description")
        formatter.example_failed(example)
        formatter.status.should be :failed
      end
    end

    describe "example pending" do
      it "should increase the number of pending tests" do
        example.stub(description: "The example description")
        formatter.example_pending(example)
        formatter.pending_count.should be 1
      end

      it "should output the pending example description" do
        example.stub(description: "The example description")
        output.should_receive(:puts).with("The example description")
        formatter.example_pending(example)
      end

      describe "status change" do
        it "changes to pending if previous status was pass" do
          example.stub(description: "The example description")
          formatter.example_pending(example)
          formatter.status.should be :pending
        end
        it "stays in failed if previous state was failed" do
          example.stub(description: "The example description")
          formatter.example_failed(example)
          formatter.example_pending(example)
          formatter.status.should be :failed
        end
      end
    end

    describe "percentage" do
      before (:each) do
        FileResolver.stub(branch_status_file: "")
        FileResolver.stub(commit_status_file: "")
        StatusReporter.stub_chain(:new, :start)
        formatter.start(5)
      end

      it "percentage is 0 is no tests run" do
        formatter.percentage.should be 0
      end

      it "calculates the right percentage" do
        example.stub(description: "The example description")
        formatter.example_failed(example)
        formatter.percentage.should be 20
      end
    end

  end
end
