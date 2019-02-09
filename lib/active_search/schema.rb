module ActiveSearch
  module Schema
    FieldDetaTypes = %w(
      text keyword
      long integer short byte
      double float half_float scaled_float
      date
      boolean
      binary
      integer_range float_range long_range double_range date_range
    )
    @@properties = {}

    def create_schema
      client.indices.create index: index, body: mappings
    end

    def delete_schema
      client.indices.delete index: index
    end

    def healthy?
      status = client.cluster.health["status"]
      status == "green"
    end

    def property(field, **options)
      if options.values.all? { |key| FieldDetaTypes.exclude?(key) }
        raise ArgumentError('invalid field deta types')
      end

      @@properties[field] = options
    end

    def properties
      @@properties
    end

    def propertie_names
      properties.keys
    end

    def mappings
      { mappings: { "#{type}" => { properties: properties } } }
    end

    def index
      ActiveSearch::Configurations.new.index
    end

    def type
      name.tableize
    end
  end
end