module CiserverFormatter
  class FileResolver
    def self.branch
      ENV['BRANCH']
    end

    def self.branch_path
      File.join(build_path, branch)
    end

    def self.commit
      ENV['COMMIT']
    end

    def self.commit_path
      File.join(build_path, branch, commit)
    end

    def self.build_path
      ENV['BUILD_PATH']
    end

    def self.progress_output_file
      File.join(build_path, 'current_test_session.txt')
    end

    def self.commit_status_file
      File.join(commit_path, 'status.txt')
    end

    def self.branch_status_file
      File.join(branch_path, 'status.txt')
    end

    def self.output_file
      File.join(commit_path, 'output.txt')
    end

  end
end
