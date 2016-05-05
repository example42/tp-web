class TinyData
  TP_PATH = Rails.root.join('tinydata', 'data')

  attr_reader :application_name, :module_path

  def initialize(application)
    raise Exception.new("Application (#{application} is not valid)") unless self.class.all.include? application
    # must set path to use tiny data or module
    @application_name = application
    set_module_path
  end

  class << self
    def all
      # List all applications
      Dir.glob("puppet-modules/modules/*/data/*/default.yaml").map do |x|
        x.match(/puppet-modules\/modules\/[^\\]+\/data\/([^\\]+)\/default.yaml/)[1]
      end.sort.uniq
    end
  end

  def has_module?
    return true unless dedicated_module_path.nil?
    false
  end

  def set_module_path
    if has_module?
      @module_path = dedicated_module_path.gsub('/default.yaml', '')
    else
      @module_path = tp_module_path.gsub('/default.yaml', '')
    end
  end

  def hiera_configs
    hiera_config = YAML.load_file(File.join(module_path, 'hiera.yaml'))
    configs = []
    hiera_config[:hierarchy].each do |folder|
      folder = folder.split('/')
      configs << folder[1] if folder[0] == "%{title}"
    end
    configs
  end

  def options_for(folder)
    entries = []
    entries = Dir.entries(File.join(module_path, folder)).select do |entry|
      !(entry =='.' || entry == '..')
    end
    entries.map { |x| x.gsub(/.yaml$/, '') }
  end

  def data_for(options = nil)
    return hiera_default_data["#{application_name}::settings"] if options.nil?
    hiera_hierarchy_data(options)
  end

  def file_options(file = nil)
    return hiera_default_data["#{application_name}::options::init"] if file.nil?
    hiera_default_data["#{application_name}::options::#{file}"]
  end

  def file_template(file = nil)
    file = initial_file if file.nil?
    return nil if file.nil?
    file.gsub!(/^#{puppet_module_name}\//, '')
    file_path = File.join(module_path, '..', '..', 'templates', file)
    return nil unless File.exist? file_path
    File.read file_path
  end

  private
    def puppet_module_name
      module_path.split('/')[2]   
    end

    def initial_file
      settings = hiera_default_data[application_name + "::settings"]
      return settings['init_file_template'] if settings.has_key? 'init_file_template'
      return settings['config_file_template'] if settings.has_key? 'config_file_template'
      nil
    end

    def dedicated_module_path
      Dir.glob("puppet-modules/modules/*/data/#{application_name}/default.yaml").select do |x|
        x unless x.match /^puppet-modules\/modules\/tinydata/
      end.first
    end

    def tp_module_path
      Dir.glob("puppet-modules/modules/*/data/#{application_name}/default.yaml").select do |x|
        x if x.match /^puppet-modules\/modules\/tinydata/
      end.first
    end

    def hiera_default_data
      YAML.load_file(File.join(module_path, 'default.yaml'))
    end

    def hiera_hierarchy_data(options)
      validate_options_keys(options)
      hash = {}
      options.keys.each do |key|
        loaded = YAML.load_file(File.join(module_path, key.to_s, "#{options[key]}.yaml" ))
        hash.merge! loaded["#{application_name}::settings"]
      end
      hiera_default_data["#{application_name}::settings"].merge! hash
    end

    def validate_options_keys(options)
      options.keys.each do |key|
        raise Exception.new("invalid key #{key} for hiera hierarchy") unless hiera_configs.include?(key.to_s)
      end
    end
end
