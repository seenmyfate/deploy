module Deploy
  class ColorFormatter
    include Colors

    def pattern
      "[#{log_level}][#{event_name}]#{event_data}"
    end

    def log_level
      cyan "%l"
    end

    def event_data
      green "%m"
    end

    def event_name
      blue "%c"
    end
  end
end
