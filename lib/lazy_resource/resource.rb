module LazyResource
  module Resource
    extend ActiveSupport::Concern
    
    def self.site=(site)
      @site = site
    end

    def self.site
      @site
    end

    module ClassMethods
      # Gets the URI of the REST resources to map for this class.  The site variable is required for
      # Active Async's mapping to work.
      def site
        if defined?(@site)
          @site
        else
          LazyResource::Resource.site
        end
      end

      # Sets the URI of the REST resources to map for this class to the value in the +site+ argument.
      # The site variable is required for Active Async's mapping to work.
      def site=(site)
        @site = site
      end

      attr_writer :element_name
      def element_name
        @element_name ||= model_name.element
      end

      attr_writer :collection_name

      def collection_name
        @collection_name ||= ActiveSupport::Inflector.pluralize(element_name)
      end

      def where(where_values)
        Relation.new(self, :where_values => where_values)
      end

      def order(order_value)
        Relation.new(self, :order_value => order_value)
      end

      def limit(limit_value)
        Relation.new(self, :limit_value => limit_value)
      end

      def offset(offset_value)
        Relation.new(self, :offset_value => offset_value)
      end
      
      def page(page_value)
        Relation.new(self, :page_value => page_value)
      end
    end

    attr_accessor :fetched

    def initialize(attributes={})
      self.tap do |resource|
        resource.load(attributes)
      end
    end

    def fetched?
      @fetched
    end
    
    # Tests for equality. Returns true iff +other+ is the same object or
    # other is an instance of the same class and has the same attributes.
    def ==(other)
      return true if other.equal?(self)
      return false unless other.instance_of?(self.class)

      self.class.attributes.inject(true) do |memo, attribute|
        attribute_name = attribute.first
        memo && self.send(:"#{attribute_name}") == other.send(:"#{attribute_name}")
      end
    end
    
    def eql?(other)
      self == other
    end

    included do
      extend ActiveModel::Naming
      include ActiveModel::Conversion
      include Attributes, Mapping, Types
    end
  end
end
