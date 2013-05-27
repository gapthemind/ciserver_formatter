module CiserverFormatter
  class StatusReporter
    def initialize(file)
      @file = file
    end

    def start
      File.open(@file, 'w') { |f| f.write("Testing") }
    end

    def finish(formatter)
      File.open(@file, 'w') { |f| f.write(formatter.status.capitalize) }
    end
  end
end
