require 'rspec/core/formatters/base_text_formatter'

module CiserverFormatter
  class CiserverFormatter <  RSpec::Core::Formatters::BaseTextFormatter
    attr_accessor :status, :passed_count, :failed_count, :pending_count, :example_count

    def initialize(output)
      super
      @status = :pass
      @passed_count = 0
      @failed_count = 0
      @pending_count = 0
      @group_level = 0
    end

    def start(example_count)
      @example_count = example_count
      StatusReporter.new(FileResolver.branch_status_file).start
      StatusReporter.new(FileResolver.commit_status_file).start
    end

    def output
      @ciserver_output ||= File.open(FileResolver.output_file, 'w')
    end

    def stop
      StatusReporter.new(FileResolver.branch_status_file).finish(self)
      StatusReporter.new(FileResolver.commit_status_file).finish(self)
    end

    def example_group_started(example_group)
      super
      output.puts "#{current_indentation}<span>#{example_group.description}</span><br />"
      @group_level += 1
    end

    def example_group_finished(example_group)
      super
      @group_level -= 1
    end

    def example_started(example)
      super
      @start_time = Time.now
    end

    def write_output(description, status)
      output.puts "#{current_indentation}<span class=\"#{status}\">#{description}<span class=\"time\">#{Time.now - @start_time}</span></span><br />"
    end

    def example_pending(example)
      super
      write_output example.description, :pending
      @status = :pending if @status == :pass
      @pending_count += 1
      update_progress
    end

    def example_failed(example)
      super
      write_output example.description, :failed
      @status = :failed
      @failed_count += 1
      update_progress
    end

    def example_passed(example)
      super
      write_output example.description, :passed
      @passed_count += 1
      update_progress
    end

    def percentage
      total_count * 100 / @example_count
    end

    def branch
      FileResolver.branch
    end

    private
    def current_indentation
      '&nsbp;&nsbp;' * @group_level
    end

    def total_count
      @failed_count + @passed_count + @pending_count
    end

    def update_progress
      ProgressReporter.new(FileResolver.progress_output_file).report(self)
    end

  end
end
