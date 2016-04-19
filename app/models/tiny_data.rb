class TinyData
  TP_PATH = Rails.root.join('tinydata', 'data')

  def initialize(application)
    raise Exception unless self.class.all.include? application
    @application = application
  end

  class << self
    def all
      Dir.entries(TP_PATH).select do |entry|
        File.directory? File.join(TP_PATH, entry) and !(entry =='.' || entry == '..')
      end
    end
  end

  def hiera_configs
    hiera_config = YAML.load_file(File.join(TinyData::TP_PATH, @application, 'hiera.yaml'))
    configs = []
    hiera_config[:hierarchy].each do |folder|
      folder = folder.split('/')
      configs << folder[1] if folder[0] == "%{title}"
    end
    configs
  end

  def options_for(folder)
    entries = []
    entries = Dir.entries(File.join(TP_PATH, @application, folder)).select do |entry|
      !(entry =='.' || entry == '..')
    end
    entries.map { |x| x.gsub(/.yaml$/, '') }
  end

  def data_for(options = nil)
    return hiera_default_data["#{@application}::settings"] if options.nil?
    hiera_hierarchy_data(options)
  end

  private
    def hiera_default_data
      YAML.load_file(File.join(TinyData::TP_PATH, @application, 'default.yaml'))
    end

    def hiera_hierarchy_data(options)
      validate_options_keys(options)
      hash = {}
      options.keys.each do |key|
        loaded = YAML.load_file(File.join(TinyData::TP_PATH, @application, key.to_s, "#{options[key]}.yaml" ))
        hash.merge! loaded["#{@application}::settings"]
      end
      hiera_default_data["#{@application}::settings"].merge! hash
    end

    def validate_options_keys(options)
      options.keys.each do |key|
        raise Exception.new("invalid key #{key} for hiera hierarchy") unless hiera_configs.include?(key.to_s)
      end
    end
end
