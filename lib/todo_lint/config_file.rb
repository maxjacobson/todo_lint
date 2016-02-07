require "yaml"

module TodoLint
  # Loads the config file (.todo-lint.yml)
  class ConfigFile
    # Parses the config file and loads the options
    # @api public
    # @example ConfigFile.new.read_config_file('.todo-lint.yml')
    # @return [Hash] parsed file-options
    def read_config_file(file)
      @config_hash = YAML.load_file(file)
      @starting_path = File.expand_path(File.split(file).first)
      @config_options = {}
      load_tags
      load_file_exclusions
      load_extension_inclusions
      config_options
    end

    private

    # Hashed form of the config file .todo-lint.yml
    # @return [Hash]
    # @api private
    attr_reader :config_hash

    # Options hash for all configurations specified by yaml file
    # @return [Hash]
    # @api private
    attr_reader :config_options

    # Starting path for all files specified in config
    # @return [String]
    # @api private
    attr_reader :starting_path

    # Adds the exclude file options to the config_options hash
    # @api private
    # @return [Hash]
    def load_file_exclusions
      return unless config_hash["Exclude Files"]
      config_options[:excluded_files] = []
      config_hash["Exclude Files"].each do |short_file|
        config_options[:excluded_files] << File.join(starting_path, short_file)
      end
    end

    # Adds the desired extensions to the config_options hash
    # @api private
    # @return [Hash]
    def load_extension_inclusions
      return unless config_hash["Extensions"]
      config_options[:extensions] = config_hash["Extensions"]
    end

    # Load the tags from the configuration file as DueDates
    #
    # @return is irrelevant
    # @api private
    def load_tags
      config_options[:tags] = {}
      return unless config_hash["Tags"]
      config_hash["Tags"].each do |tag, due_date|
        unless due_date.is_a? Date
          raise ArgumentError, "#{due_date} is not a date"
        end

        config_options[:tags]["##{tag}"] = DueDate.new(due_date)
      end
    end
  end
end
