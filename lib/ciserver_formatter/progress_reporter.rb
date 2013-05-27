module CiserverFormatter
  class ProgressReporter

    def initialize(output_file)
      @output_file = output_file
    end

    def report(formatter)
      File.open(@output_file, 'w') { |f| f.write(output_for_formatter(formatter)) }
    end

    private
    def output_for_formatter(formatter)
      """branch:#{formatter.branch}
test_session_status:#{formatter.status.capitalize}
percentage_run:#{formatter.percentage}
failed_count:#{formatter.failed_count}
pending_count:#{formatter.pending_count}
passed_count:#{formatter.passed_count}
example_count:#{formatter.example_count}
      """
    end

  end
end
